module StripeData
  extend ActiveSupport::Concern

  def stripe_config
    host.integrations[Integration::STRIPE].try(:config)
  end

  def stripe_charge
    metadata['details']
  end

  def stripe_refunds
    @refunds ||= stripe_charge['refunds'].try(:[], 'data').map do |refund_data|
      StripeRefund.new(refund_data)
    end
  end

  # includes the fee breakdown
  def stripe_balance_transaction

  end

  def stripe_net_amount
    initial_amount = stripe_charge['amount'] || 0
    refunded = stripe_charge['amount_refunded'] || 0

    initial_amount - refunded
  end
end
