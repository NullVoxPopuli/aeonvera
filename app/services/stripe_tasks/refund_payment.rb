# frozen_string_literal: true

module StripeTasks
  module RefundPayment
    module_function

    # @param [Order] order
    # @param [Hash] refund_params
    #   @option [string] refund_type
    #   @option [number] partial_refund_amount
    def run(order, refund_params)
      refund(order, refund_params)
      StripeTasks::RefreshCharge.run(order)
    end

    def refund(order, refund_params)
      type = refund_params[:refund_type]
      # convert to cents
      amount = (refund_params[:partial_refund_amount].to_f * 100).round

      stripe_refund_params = { charge: order.stripe_charge['id'] }
      stripe_refund_params[:amount] = amount if type == 'partial'

      stripe_account_id = order.host.integrations[Integration::STRIPE].try(:config).try(:[], 'stripe_user_id')

      Stripe::Refund.create(stripe_refund_params, stripe_account: stripe_account_id)
    end
  end
end
