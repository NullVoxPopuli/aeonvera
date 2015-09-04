class PaymentsController < ApplicationController
  include SetsHost
  include MarkPaid
  include StripeCharge

  before_action :load_integration, only: [ :create ]
  before_action :load_order
  before_action :load_attendance

  def create
    if @order.sub_total > 0
      if charge_card!
        payment_successful
      end
    else
      # sub total is zero, set to paid
      @order.paid = true
      @order.payment_method = Payable::Methods::Cash
      @order.save
    end

    respond_to do |format|
      format.js{
        mark_paid(skip: true)
      }

      format.html{
        if params[:return_path].present?
          redirect_to params[:return_path]
        else
          redirect_to register_index_path
        end

      }
    end
  end

  def index
  end

  private



  def payment_successful
    flash[:notice] = "Payment Recieved"
    AttendanceMailer.payment_received_email(order: @order).deliver_now
  end

  def load_integration
    @integration = @host.integrations[Integration::STRIPE]
    raise "Stripe not connected to #{@host.name}" unless @integration
  end

  def load_attendance
    @attendance = @order.attendance
  end

  def load_order
    @order = current_user.orders.find_by_id(params[:order_id])
    @order = @event.orders.find_by_id(params[:order_id]) unless @order
  end

end
