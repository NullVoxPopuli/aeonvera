# example charge, and then refund
# initial charge: 105 <- also net received
# added fees:     4.29
#  aeonvera:      0.82
#  stripe:        3.47
# amount paid:    109.29
#
# amount refunded:        20.75
# stripe fees refund:     0.60
#
# new amount paid:  109.29 - 20.75 = 88.54
# final fee:        4.29 - 0.60 = 3.69
# new net received: 105 - (20.75 - 0.60) = 84.85
#                   109.29 - 20.75 - 3.69 = 84.85
module StripeRefreshCharge
  module_function

  def update(order)
    charge_id = order.stripe_charge.try(:[], "id")
    return unless charge_id

    stripe_config = order.stripe_config
    return unless stripe_config
    token = stripe_config["access_token"]
    charge_object = Stripe::Charge.retrieve(charge_id, token)
    # this will give us
    # - amount_received
    # - amount_refunded
    # - refunds: data: [ refund data ]
    order.metadata['details'] = charge_object.as_json

    # re-calculate everything
    refund_amount = order.stripe_amount_refunded / 100.0
    refund_totals = calculate_totals_after_refund(order, refund_amount)

    order.current_paid_amount = refund_totals[:paid_amount]
    order.current_net_amount_received = refund_totals[:net_amount_received]
    order.current_total_fee_amount = refund_totals[:total_fee_amount]
  end

  def calculate_totals_after_refund(order, refund_amount)
    refund_data = PriceCalculator.calculate_refund(refund_amount)
    new_fee = order.total_fee_amount - refund_data[:total_fee]
    new_net_received = order.net_amount_received - refund_data[:received_by_event]

    {
      paid_amount: order.paid_amount - refund_amount,
      net_amount_received: new_net_received,
      total_fee_amount: new_fee
    }
  end

end
