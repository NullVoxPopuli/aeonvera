class Api::OrdersController < APIController

  include HostLoader
  include StripeCharge

  before_action :find_host_params, only: [:create, :update]
  before_action :sets_host, only: [:create, :update]
  before_action :load_integration, only: [:update, :create]

  def index
    operation = Operations::Order::ReadAll.new(current_user, params)

    render json: operation.run
  end

  def show
    operation = Operations::Order::Read.new(current_user, params)
    render json: operation.run
  end

  def create
    @order = orders_proxy.new(order_params)

    @order.save

    respond_with @order
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

  private

  def order_where_params
    keys = (Order.column_names & params.keys)
    params.slice(*keys).symbolize_keys
  end

  def orders_proxy
    parent = (@host || @event)# || current_user)
    (parent ? parent.orders : Order)
  end

  def load_integration
    @integration = (@host || @event).integrations[Integration::STRIPE]
    raise "Stripe not connected to #{@host.name}" unless @integration
  end

  def order_params
    params[:order].permit(:paid_amount, :payment_method, :attendance_id)
  end

  def all_order_params
    params[:order].permit(
      :paid_amount, :payment_method, :check_number, :stripe_data, :attendance_id
    )
  end

  def stripe_params
    params[:order].permit(
      :checkout_token, :checkout_email
    )
  end

  def find_host_params
    o_params = params[:order]
    params[:host_id] = o_params[:host_id]
    params[:host_type] = o_params[:host_type]
  end

end
