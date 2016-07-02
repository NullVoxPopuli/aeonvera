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

    # re-calculate fees?
    # re-calculate net received?
    # maybe add another column for current total paid and
    # current fee total
  end

end
