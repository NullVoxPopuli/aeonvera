# frozen_string_literal: true
# TODO: make the payment handlers polymorphic,
# separate classes, but not models
# TODO: service?
module StripePaymentHandler
  extend ActiveSupport::Concern

  # handles the successful charge for an order from stripe
  def handle_stripe_charge(charge)
    # the following fields will more or less be based
    # off of the data on set by this call .
    # charge object is stored in metadata under the
    # 'details' key.
    # TODO: why is this being converted to and from JSON?
    json = JSON.parse(charge.to_json)
    set_payment_details(json)

    if timeNum = json['created']
      self.payment_received_at = Time.at(timeNum)
    end

    self.paid = charge.paid
    self.payment_method = Payable::Methods::STRIPE
    self.paid_amount = calculate_paid_amount
    set_net_amount_received_and_fees_from_stripe

    # these 3 fields are used in calculations, as
    # they'll contain the aggregation of any possible
    # refunds
    self.current_paid_amount = paid_amount
    self.current_total_fee_amount = total_fee_amount
    self.current_net_amount_received = net_amount_received

    save
  end

  def paid_amount_from_stripe_charge_data
    details = metadata['details']

    if details.present?
      # stripe stores money as cents
      details['amount'] / 100.0
    else
      # if the charge isn't present, we don't know
      # for sure if they actually paid.
      # assume they paid nothing.
      0
    end
  end

  def get_stripe_transaction_id
    transaction = {}
    details = metadata['details']

    if details
      # gotta pull out the transaction
      transaction_id = details['balance_transaction']

      # retrieve the transaction
      # first the the access token for the event's Stripe payment processor
      integration = host.integrations[Integration::STRIPE]
      key = integration.config['access_token']

      transaction = Stripe::BalanceTransaction.retrieve(transaction_id, key)
    end

    transaction
  end

  def set_net_amount_received_and_fees_from_stripe
    transaction = get_stripe_transaction_id

    # Stripe stores all of its money in cents
    # also verify that we actually got the data, it's possible that the payment
    # was marked as Stripe, but was marked paid anyway (even though the
    # transaction may have been in cash or check)
    fee = transaction.try(:[], 'fee') ? transaction['fee'] / 100.0 : 0
    net = transaction.try(:[], 'net') ? transaction['net'] / 100.0 : paid_amount

    self.total_fee_amount = fee
    self.net_amount_received = net
  end
end
