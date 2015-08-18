class PaymentsController < ApplicationController
  include SetsHost

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

    redirect_to register_index_path
  end

  def index
  end

  private

  def charge_card!
    token = params[:stripeToken]
    email = params[:stripeEmail]

    # the access token here is what determines
    # what account the charge gets sent to
    secret_key = @integration.config[:access_token]

    amount = @order.total

    begin
      chargeData =  {
        amount: to_cents(amount),
        currency: "usd",
        source: token,
        description: email,
        statement_descriptor: statement_description(@host.name).gsub(/'/, ''),
        receipt_email: email
      }

      unless @host.beta?
        chargeData[:application_fee] = to_cents(@order.fee)
      end


      charge = Stripe::Charge.create(
        chargeData,
        # the account to charge to
        secret_key
      )

      @order.handle_stripe_charge(charge)

      return true
    rescue Stripe::CardError => e
      # The card has been declined
      flash[:error] = e.message
    end
    return false
  end

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
  end

  # @param [Integer] from amount to be charged
  # @param [Integer] multiplier what to multiply the amount by
  # @param [Symbol] output conversion method
  def to_cents(from, multiplier: 100, output: :to_i)
    (from * multiplier).send(output)
  end

  def statement_description(string)
    string.length > 15 ? string[0..14] : string
  end
end
