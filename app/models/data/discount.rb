# frozen_string_literal: true
# == Schema Information
#
# Table name: discounts
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  value                  :decimal(, )
#  kind                   :integer
#  disabled               :boolean          default(FALSE)
#  affects                :string(255)
#  host_id                :integer
#  created_at             :datetime
#  updated_at             :datetime
#  deleted_at             :datetime
#  allowed_number_of_uses :integer
#  host_type              :string(255)
#  discount_type          :string(255)
#  requires_student_id    :boolean          default(FALSE)
#
# Indexes
#
#  index_discounts_on_host_id_and_host_type  (host_id,host_type)
#

# @TODO consider breaking this out in to:
#   PercentDiscount, and AmountDiscount,
#   or something similarly named
class Discount < ApplicationRecord
  self.inheritance_column = 'discount_type'

  include SoftDeletable
  include Purchasable
  include CSVOutput

  belongs_to :host, polymorphic: true

  belongs_to :event, class_name: Event.name,
                     foreign_key: 'host_id', foreign_type: 'host_type'

  belongs_to :organization, class_name: Organization.name,
                            foreign_key: 'host_id', foreign_type: 'host_type'

  # discounts depend on the restrainted item (such as a package)
  has_many :restraints, as: :dependable
  has_many :allowed_packages, through: :restraints,
                              source: :restrictable, source_type: Package.name

  has_many :order_line_items, as: :line_item
  has_many :sponsorships, as: :discount

  accepts_nested_attributes_for :restraints, allow_destroy: true
  # this in handled manually
  # TODO: have ember create restraints without the discounts
  # this association should never be used, this is specifically
  # for form building
  has_many :add_restraints, class_name: Restraint.name
  accepts_nested_attributes_for :add_restraints, reject_if: -> { true }

  DOLLARS_OFF = 0
  PERCENT_OFF = 1

  AFFECTS_FINAL_PRICE = 'Final Price'

  KIND_NAMES = {
    DOLLARS_OFF => 'Dollars Off',
    PERCENT_OFF => 'Percent Off'
  }.freeze

  alias_attribute :applies_to, :affects
  alias_attribute :code, :name
  alias_attribute :amount, :value
  alias_attribute :percent, :value

  validates :code, presence: true
  validates :amount, presence: true
  validate :code_is_valid?

  def restrained_to?(item)
    restraints.select do |r|
      r.dependable_id == item.id &&
        r.dependable_type == item.class.name
    end.present?
  end

  def times_used
    order_line_items.count
  end

  def can_be_used?
    if allowed_number_of_uses.present?
      return times_used < allowed_number_of_uses
    end

    true
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

  # TODO: Move this to a discount decorator
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
      0 - value
    else
      # percent
      0 - (item.price * value_as_percent)
    end
  end

  # @praam [Number] total the total cost / value
  # @return [Number] the total with the discount applied
  def apply_discount_to_total(total)
    if amount_discount?
      total - value
    else
      total * (1 - value_as_percent)
    end
  end

  def has_restraints?
    restraints.present?
  end

  def amount_discount?
    kind == DOLLARS_OFF
  end

  def percent_discount?
    kind == PERCENT_OFF
  end

  private

  # simple conversion to percent
  def value_as_percent
    value / 100
  end

  def code_is_valid?
    if code.present? && code.include?('&')
      errors.add(:code, 'must not contain "&"')
    end
  end
end
