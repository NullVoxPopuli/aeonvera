module Payable
  module Methods
    PAYPAL = "PayPal"
    CHECK = "Check"
    CREDIT = "Credit"
    DEBIT = "Debit"
    CASH = "Cash"
    STRIPE = "Stripe"

    ALL = [
      PAYPAL,
      STRIPE,
      CHECK,
      CREDIT,
      DEBIT,
      CASH
    ]

    FEES = {
      STRIPE => Proc.new{ |amount|
        # 30 cents + 2.9%
        0.30 + (amount * 0.029)
        # $100 + (($100.3 / 0.975) * 0.25) + 0.3
        # amount + ((amount / 1 - 0.029) - 0.3) * 1.029 + 0.3
      },
      PAYPAL => Proc.new{ |amount|
        # 30 cents + 2.9%
        0.30 + (amount * 0.029)
        # (amount + ((amount / (1 - 0.029)) - 0.3) * 0.029 + 0.3).round(2)
      }
    }

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

  def fee
    self.total * 0.0075 # 0.75%
  end

  def add(object, quantity: 1, price: nil)

    if object.is_a?(Discount)
      return false unless eligible_for_discount?
      return false unless discount_is_eligible?(object)
    end

    if already_exists?(object)
      if is_an_item_with_quantity?(object)
        increment_quantity_of_line_item_matching(object)
      end
    else
      create_line_item(object, quantity: quantity, price: price)
    end
  end


  # check if the discount is allowed for this order
  def discount_is_eligible?(object)
    allowed = object.allowed_packages
    if allowed.present?
      # ensure just one of the allowed packages is present
      # in this order
      package_eligibility = allowed.map do |package|
        item_exists = already_exists?(package)
      end

      return false unless package_eligibility.any?
    end

    true
  end

  def eligible_for_discount?
    if !allows_discounts?
      return false
    end

    if already_has_discount? && !allows_multiple_discounts?
      return false
    end

    return true
  end

  def is_an_item_with_quantity?(item)
    if [Discount, Competition, Package].include?(item.class)
      return false
    else
      return true
    end
  end

  def allows_discounts?
    host.allow_discounts?
  end

  def allows_multiple_discounts?
    host.allow_combined_discounts?
  end

  def already_has_discount?
    self.line_items.select{|line_item|
      line_item.line_item_type == Discount.name
    }.count > 0
  end

  def increment_quantity_of_line_item_matching(object)
    # find existing line item with same id and type
    line_item = line_item_matching(object)
    # increment quantity and save
    line_item.quantity += 1
    line_item.save
  end

  def already_exists?(object)
    !!line_item_matching(object)
  end

  def line_item_matching(object)
    self.line_items.select{|line_item|
      line_item.line_item_id == object.id &&
      line_item.line_item_type == object.class.name
    }.first
  end

  def add_check_number(number)
    check_data = checks
    check_data << {
      number: number
    }
    self.checks = check_data
  end

  def sub_total
    return legacy_total if is_legacy?
    amount = 0
    remaining_discounts = []
    discounts_to_apply_at_end = ->(discount){
      remaining_discounts << discount
    }

    self.line_items.each do |line_item|
      if (object = line_item.line_item).is_a?(Discount)
        amount = amount_after_discount(
          amount,
          object,
          order_line_item: line_item,
          discounts_to_apply_at_end: discounts_to_apply_at_end
        )
      elsif (object = line_item.line_item).is_a?(LineItem::Shirt)
        # shirts can have different prices per size.
        # hopefully this will become easier to manage when
        # an attendance has shirt option responses, rather than shirts
        amount += self.attendance.total_cost_for_selected_shirt(object.id)
      else
        amount += (line_item.price * line_item.quantity)
      end

    end

    amount = amount_after_global_discounts(amount, remaining_discounts)

    amount > 0 ? amount : 0
  end

  def total
    sub = sub_total
    total = sub

    # optionally make the registrant pay more
    if host.make_attendees_pay_fees? &&
        (self.payment_method == Payable::Methods::STRIPE ||
         self.payment_method == Payable::Methods::PAYPAL)
        total_fee_percentage = 0.029 # Stripe
        total_fee_percentage += 0.0075 unless host.beta?

        total = (sub + 0.3) / (1 - total_fee_percentage).round(2)
    end

    total
  end

  def net_received
    net_amount_received == 0 ? total : net_amount_received
  end

  def is_legacy?
    !!self.metadata["line_items"].present?
  end


  def checks
    items_from_metadata("checks")
  end

  def checks=(checks)
    self.metadata["checks"] = checks
  end

  def calculate_paid_amount
    if self.paid?
      if self.payment_method == Payable::Methods::STRIPE &&
          self.metadata["details"]
        # stripe stores money as cents
        self.metadata["details"]["amount"] / 100.0
      else
        total
      end
    else
      0
    end
  end

  def items_from_metadata(key)
    c = (self.metadata[key] || [])
    c.map{|h| h.default_proc = proc do |h, k|
        case k
        when String then sym = k.to_sym; h[sym] if h.key?(sym)
        when Symbol then str = k.to_s; h[str] if h.key?(str)
        end
      end
    }
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
    item = self.line_items.new(
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
