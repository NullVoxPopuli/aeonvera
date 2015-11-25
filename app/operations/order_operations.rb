module OrderOperations
  class Update < SkinnyControllers::Operation::Base

    def run
      if allowed?
        update
      else
        # TODO: how to send error?
        raise 'not authorized'
      end
    end

    def update
      order = model
      order_params = params[:order]
      stripe_params = params[:stripe]

      if order_params[:payment_method] != Payable::Methods::STRIPE
        order.check_number = order_params[:check_number]

        order.paid = true
        order.paid_amount = order_params[:paid_amount]
        order.net_amount_received = order.paid_amount
        order.total_fee_amount = 0
      else
        integration = order.host.integrations[Integration::STRIPE]

        if stripe_params[:checkout_token].present?
          # absorbing fees should only be at the door.
          # TODO: find a way to verify if an order update is coming from a payment from pre-registraiton
          #       or if it is coming from at the door
          order = StripeCharge.charge_card!(
            stripe_params[:checkout_token],
            stripe_params[:checkout_email],
            absorb_fees: true,
            secret_key: integration.config[:access_token],
            order: order)
        else
          order.errors.add(:base, "No Stripe Information Found")
        end

      end

      order.save if order.errors.full_messages.empty?

      order
    end
  end

  class SendReceipt < SkinnyControllers::Operation::Base
    def run
      if allowed?
        AttendanceMailer.payment_received_email(order: model).deliver_now
      else
        # TODO: how to sent error to ember?
        raise 'not authorized'
      end
    end
  end
end
