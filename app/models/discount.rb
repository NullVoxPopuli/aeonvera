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

  has_many :restraints, as: :dependable
  has_many :allowed_packages, through: :restraints,
    source: :restrictable, source_type: Package.name

  has_many :order_line_items, as: :line_item

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

  def discount
    case kind
    when DOLLARS_OFF
      "$ #{value}"
    when PERCENT_OFF
      "#{value}%"
    end
  end

  def display_value
    "-#{discount}"
  end

  private

  def code_is_valid?
    if code.present? and code.include?("&")
      errors.add(:code, 'must not contain "&"')
    end
  end

end