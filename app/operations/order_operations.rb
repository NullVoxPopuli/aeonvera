module OrderOperations
  class Update < SkinnyControllers::Operation::Base
    include StripeCharge

    def run
      if allowed?
        update
      else
        # TODO: how to send error?
        raise 'not authorized'
      end
    end

    def update
      @order = @host.orders.find(params[:id])

      if order_params[:payment_method] != Payable::Methods::STRIPE
        @order.check_number = all_order_params[:check_number]

        @order.paid = true
        @order.paid_amount = all_order_params[:paid_amount]
        @order.net_amount_received = @order.paid_amount
        @order.total_fee_amount = 0
      else

        if stripe_params[:checkout_token].present?
          charge_card!(stripe_params[:checkout_token], stripe_params[:checkout_email], absorb_fees: true)
        else
          @orders.errors.add(:base, "No Stripe Information Found")
        end

      end

      @order.save if @order.errors.full_messages.empty?

      respond_with @order
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
