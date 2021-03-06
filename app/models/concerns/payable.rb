# frozen_string_literal: true

module Payable
  module Methods
    PAYPAL = 'PayPal'
    CHECK = 'Check'
    CREDIT = 'Credit'
    DEBIT = 'Debit'
    CASH = 'Cash'
    STRIPE = 'Stripe'

    ALL = [
      PAYPAL,
      STRIPE,
      CHECK,
      CREDIT,
      DEBIT,
      CASH
    ].freeze

    FEES = {
      STRIPE => proc do |amount|
        # 30 cents + 2.9%
        0.30 + (amount * 0.029)
        # $100 + (($100.3 / 0.975) * 0.25) + 0.3
        # amount + ((amount / 1 - 0.029) - 0.3) * 1.029 + 0.3
      end,
      PAYPAL => proc do |amount|
        # 30 cents + 2.9%
        0.30 + (amount * 0.029)
        # (amount + ((amount / (1 - 0.029)) - 0.3) * 0.029 + 0.3).round(2)
      end
    }.freeze
  end

  FEES = Payable::Methods::FEES

  extend ActiveSupport::Concern

  # original implementation
  # - didn't have references to line items
  include LegacyPayable

  # metadata item lists should be an array of hashes
  # [
  #   {name: "Dance", quantity: 3, price: 5},
  #   {name: "Shirt", quantity: 1, price: 7}
  # ]

  def application_fee
    total * 0.0075 # 0.75%
  end

  # check if the discount is allowed for this order
  def discount_is_eligible?(object)
    allowed = object.allowed_packages
    if allowed.present?
      # ensure just one of the allowed packages is present
      # in this order
      package_eligibility = allowed.map do |package|
        already_exists?(package)
      end

      return false unless package_eligibility.any?
    end

    true
  end

  def eligible_for_discount?
    return false unless allows_discounts?

    return false if already_has_discount? && !allows_multiple_discounts?

    true
  end

  def is_an_item_with_quantity?(item)
    if [Discount, Competition, Package].include?(item.class)
      false
    else
      true
    end
  end

  def allows_discounts?
    host.allow_discounts?
  end

  def allows_multiple_discounts?
    host.allow_combined_discounts?
  end

  def already_has_discount?
    order_line_items.select do |line_item|
      line_item.line_item_type == Discount.name
    end.count.positive?
  end

  def already_exists?(object)
    !!line_item_matching(object)
  end

  def line_item_matching(object)
    order_line_items.select do |line_item|
      line_item.line_item_id == object.id &&
        line_item.line_item_type == object.class.name
    end.first
  end

  def add_check_number(number)
    return unless number.present?
    check_data = checks
    check_data << {
      number: number
    }
    self.checks = check_data
  end

  def check_number=(number)
    add_check_number(number)
  end

  def check_number
    checks.first.try(:[], 'number')
  end

  # In Dollars
  def sub_total
    (sub_total_in_cents || ensure_sub_total_persisted) / 100.0
  end

  def ensure_sub_total_persisted
    self.sub_total_in_cents = _calculate_sub_total * 100
    save
    sub_total_in_cents
  end

  def _calculate_sub_total
    return legacy_total if is_legacy?
    amount = 0
    remaining_discounts = []
    discounts_to_apply_at_end = lambda do |discount|
      remaining_discounts << discount
    end

    valid_order_line_items = order_line_items
    valid_order_line_items.each do |order_line_item|
      if order_line_item.line_item_type.include?('Discount')
        object = order_line_item.line_item
        amount = amount_after_discount(
          amount,
          object,
          order_line_item: order_line_item,
          discounts_to_apply_at_end: discounts_to_apply_at_end
        )
      else
        amount += (order_line_item.price * order_line_item.quantity)
      end
    end

    amount = amount_after_global_discounts(amount, remaining_discounts)
    any_negative = valid_order_line_items.select { |o| o.quantity < 0 }.any?
    amount > 0 || any_negative ? amount : 0
  end

  def should_apply_fee?
    sub_total > 0 &&
      !is_fee_absorbed &&
      (payment_method == Payable::Methods::STRIPE ||
       payment_method == Payable::Methods::PAYPAL)
  end

  def calculated_price(charge_fees: true)
    absorb_fees = !charge_fees
    PriceCalculator.calculate_for_sub_total(
      sub_total,
      absorb_fees: absorb_fees,
      allow_negative: has_item_of_negative_quantity?
    )
  end

  # when absorb_fees is false, it defaults to should_apply_fee
  # this kind of a hacky way to get around the varying prices at the door.
  # everything is just easier when organizers don't do 'convinience fees'.
  # it'ls also better for morale to not charge extra fees.
  def total(absorb_fees: false)
    charge_fee = !absorb_fees && should_apply_fee?
    calculated = calculated_price(charge_fees: charge_fee)

    calculated[:total]
  end

  def has_item_of_negative_quantity?
    order_line_items.select { |o| o.quantity < 0 }.any?
  end

  def net_received
    net_amount_received == 0 ? total : net_amount_received
  end

  def is_legacy?
    !!metadata['line_items'].present?
  end

  def checks
    items_from_metadata('checks')
  end

  def checks=(checks)
    metadata['checks'] = checks
  end

  def calculate_paid_amount
    if paid?
      if payment_method == Payable::Methods::STRIPE
        paid_amount_from_stripe_charge_data
      else
        total
      end
    else
      0
    end
  end

  def items_from_metadata(key)
    c = (metadata[key] || [])
    c.map do |h|
      h.default_proc = proc do |h, k|
        case k
        when String then sym = k.to_sym; h[sym] if h.key?(sym)
        when Symbol then str = k.to_s; h[str] if h.key?(str)
        end
      end
    end
    c
  end

  private

  # this should only be called after validation has been
  # performed on the object.
  #
  # @see #add
  # @param [LineItem] object discount or payable item
  # @param [Number] quantity number of items
  # @param [Decimal] price monetary value
  # @return [OrderLineItem] the created order line item
  def create_line_item(object, quantity: 1, price: nil)
    price ||= (object.try(:current_price) || object.try(:value))
    item = order_line_items.new(
      quantity: quantity,
      price: price
    )

    item.line_item_id = object.id
    item.line_item_type = object.class.name
    item.save
    item
  end

  def amount_after_discount(amount, discount, order_line_item: nil, discounts_to_apply_at_end: nil)
    discount_from = amount
    quantity = order_line_item.quantity

    # check if the discount is to only apply to one item
    allowed = discount.allowed_packages
    apply_to = nil
    if allowed.present?
      package_eligibility = allowed.each do |package|
        if already_exists?(package)
          apply_to = package
          break
        end
      end
    end

    if apply_to.present?
      applicable_line_item = line_item_matching(apply_to)
      quantity = applicable_line_item.quantity
      discount_from = applicable_line_item.price
    else
      if discount.percent_discount?
        # discounts will be applied after the amount is totaled
        discounts_to_apply_at_end.call(discount)
        return amount
      end
    end

    if discount.amount_discount?
      amount -= (discount.value * quantity)
    elsif apply_to.present?
      amount -= (discount_from * discount.value / 100.0)
    else
      discounts_to_apply_at_end.call(discount)
    end

    amount
  end

  # applies global discounts that are not tied to any particular item
  # @param [Decimal] amount
  # @param [Array] discounts list of discounts to apply
  # @return [Number] the new amount
  def amount_after_global_discounts(amount, discounts)
    discounts.each do |discount|
      if discount.amount_discount?
        amount -= discount.value
      else discount.percent_discount?
           amount -= (amount * discount.value / 100.0)
      end
    end

    amount
  end
end
