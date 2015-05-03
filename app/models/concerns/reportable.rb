module Reportable
  extend ActiveSupport::Concern

  # ideally, this is ran upon successful payment
  def set_net_amount_received_and_fees

    if self.payment_method == Payable::Methods::STRIPE
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

end
