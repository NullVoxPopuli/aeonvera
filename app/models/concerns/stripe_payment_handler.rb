module StripePaymentHandler
  extend ActiveSupport::Concern

  # handles the successful charge for an order from stripe
  def handle_stripe_charge(charge)
    # the following fields will more or less be based
    # off of the data on set by this call .
    # charge object is stored in metadata under the
    # 'details' key.
    self.set_payment_details(JSON.parse(charge.to_json))

    self.paid = charge.paid
    self.payment_method = Payable::Methods::STRIPE
    self.paid_amount = self.calculate_paid_amount
    self.set_net_amount_received_and_fees

    self.save
  end

  def paid_amount_from_stripe_charge_data
    details = self.metadata["details"]

    if details.present?
      # stripe stores money as cents
      details["amount"] / 100.0
    else
      # if the charge isn't present, we don't know
      # for sure if they actually paid.
      # assume they paid nothing.
      0
    end
  end

  def set_net_amount_received_and_fees_from_stripe
    transaction = {}
    details = self.metadata["details"]

    if details
      # gotta pull out the transaction
      transaction_id = details["balance_transaction"]

      # retrieve the transaction
      # first the the access token for the event's Stripe payment processor
      integration = self.event.integrations[Integration::STRIPE]
      key = integration.config["access_token"]

      transaction = Stripe::BalanceTransaction.retrieve(transaction_id, key)

    end

    # Stripe stores all of its money in cents
    # also verify that we actually got the data, it's possible that the payment
    # was marked as Stripe, but was marked paid anyway (even though the
    # transaction may have been in cash or check)
    fee = transaction.try(:[], "fee") ? transaction["fee"] / 100.0 : 0
    net = transaction.try(:[], "net") ? transaction["net"] / 100.0 : self.paid_amount

    self.total_fee_amount = fee
    self.net_amount_received = net
  end

end
