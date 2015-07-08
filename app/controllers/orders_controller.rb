class OrdersController < ApplicationController

  def show
		# history of orders
  end

  def index

  end

  # def paid
  #   if order = Order.pay(
  #       token: params[:token],
  #       payer_id: params[:PayerID],
  #       payment_method: Payable::Methods::PAYPAL
  #     )
  #     flash[:notice] = "Thank you for your payment."
  #     AttendanceMailer.thankyou_email(order: order).deliver_now
  #   else
  #     flash[:error] = "An error occured with your payment."
  #   end
  #
  #   current_event = Event.find(params[:event_id])
  #   redirect_to current_event.url + "/" + register_path(current_user.attendance_for_event(current_event))
  # end

  def cancel
    if order = Order.cancel_payment(params)
      flash[:notice] = "Payment Cancelled"
    end

    redirect_to register_path(current_user.attendance_for_event(current_event))
  end

  def ipn
    if payment = Payment.find_by_transaction_id(params[:txn_id])
      payment.receive_ipn(params)
    else
      Payment.create_by_ipn(params)
    end

    render nothing: true
  end
end
