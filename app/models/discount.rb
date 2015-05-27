# @TODO consider breaking this out in to:
#   PercentDiscount, and AmountDiscount,
#   or something similarly named
class Discount < ActiveRecord::Base
  self.inheritance_column = "discount_type"

  include SoftDeletable

  belongs_to :host, polymorphic: true

  belongs_to :event, class_name: Event.name,
  	foreign_key: "host_id", foreign_type: "host_type"

  belongs_to :organization, class_name: Organization.name,
  	foreign_key: "host_id", foreign_type: "host_type"

  has_and_belongs_to_many :attendances,
    join_table: "attendances_discounts",
    association_foreign_key: "attendance_id", foreign_key: "discount_id"

  # discounts depend on the restrainted item (such as a package)
  has_many :restraints, as: :dependable
  has_many :allowed_packages, through: :restraints,
    source: :restrictable, source_type: Package.name

  has_many :order_line_items, as: :line_item

  accepts_nested_attributes_for :restraints, allow_destroy: true
  # this in handled manually
  # TODO: have ember create restraints without the discounts
  # this association should never be used, this is specifically
  # for form building
  has_many :add_restraints, class_name: Restraint.name
  accepts_nested_attributes_for :add_restraints, reject_if: ->{ true }


  DOLLARS_OFF = 0
  PERCENT_OFF = 1

  AFFECTS_FINAL_PRICE = "Final Price"

  KIND_NAMES = {
    DOLLARS_OFF => "Dollars Off",
    PERCENT_OFF => "Percent Off"
  }

  alias_attribute :applies_to, :affects
  alias_attribute :code, :name
  alias_attribute :amount, :value
  alias_attribute :percent, :value

  validates :code, presence: true
  validate :code_is_valid?

  def restrained_to?(item)
    self.restraints.select{|r|
      r.dependable_id == item.id &&
      r.dependable_type == item.class.name
    }.present?
  end

  def times_used
    order_line_items.count
  end

  def can_be_used?
    if self.allowed_number_of_uses.present?
      return self.times_used < self.allowed_number_of_uses
    end

    return true
  end

  def kind_name
    KIND_NAMES[kind]
  end

  # @TODO Move this to a discount decorator
  def discount
    case kind
    when DOLLARS_OFF
      "$ #{value}"
    when PERCENT_OFF
      "#{value}%"
    end
  end

  # TODO Move this to a discount decorator
  def display_value
    "-#{discount}"
  end

  # @param [LineItem] any object that has a price method that returns a number
  # @return a (hopefully) negative number representing
  #   how much money will be added to the item's cost.
  #   this value is returned as negative, because if
  #   all discounted values are negative, then it's easier
  #   to decide how to display the discount in human-readable
  #   terms.
  def discounted_amount_of(item)
    if amount_discount?
      return 0 - self.value
    else
      # percent
      return 0 - (item.price * value_as_percent)
    end
  end

  # @praam [Number] total the total cost / value
  # @return [Number] the total with the discount applied
  def apply_discount_to_total(total)
    if amount_discount?
      return total - self.value
    else
      return total * (1 - value_as_percent)
    end
  end


  def has_restraints?
    self.restraints.present?
  end


  def amount_discount?
    self.kind == DOLLARS_OFF
  end

  def percent_discount?
    self.kind == PERCENT_OFF
  end

  private

  # simple conversion to percent
  def value_as_percent
    self.value / 100
  end

  def code_is_valid?
    if code.present? and code.include?("&")
      errors.add(:code, 'must not contain "&"')
    end
  end

end
