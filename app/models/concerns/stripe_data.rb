# frozen_string_literal: true
module StripeData
  extend ActiveSupport::Concern

  def stripe_config
    host.integrations[Integration::STRIPE].try(:config)
  end

  def stripe_charge
    @stripe_charge ||= metadata['details'] || {}
  end

  def stripe_refunds
    stripe_charge['refunds'].try(:[], 'data') || []
  end

  # includes the fee breakdown
  def stripe_balance_transaction
  end

  def stripe_net_amount_paid
    stripe_amount_paid - stripe_amount_refunded
  end

  def stripe_amount_paid
    stripe_charge['amount'] || 0
  end

  def stripe_amount_refunded
    stripe_charge['amount_refunded'] || 0
  end
end
