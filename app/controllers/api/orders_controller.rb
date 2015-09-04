class Api::OrdersController < APIController

  include HostLoader

  before_action :find_host_params, only: [:create, :update]
  before_action :sets_host, only: [:create, :update]


  def index
    @orders = current_user.orders
    render json: @orders,
      each_serializer: OrderSerializer, root: :orders
  end

  def show
    @order = current_user.orders.find(params[:id])
    render json: @order
  end

  def create
    @order = @host.orders.new(order_params)
    create_or_update
  end

  def update
    @order = @host.orders.find(params[:id])
    create_or_update
  end

  private

  def create_or_update
    @order.check_number = all_order_params[:check_number]


    if @order.payment_method == Payable::Methods::STRIPE &&
      (stripe_data = all_order_params[:stripe_data]).present?

      # this should be a stripe charge object
      @order.handle_stripe_charge(stripe_data)
    else
      @order.paid = true
      @order.net_amount_received = @order.paid_amount
      @order.total_fee_amount = 0
    end

    @order.save

    respond_with @order
  end



  def order_params
    params[:order].permit(
      :paid_amount, :payment_method
    )
  end

  def all_order_params
    params[:order].permit(
      :paid_amount, :payment_method, :check_number, :stripe_data
    )
  end

  def find_host_params
    o_params = params[:order]
    params[:host_id] = o_params[:host_id]
    params[:host_type] = o_params[:host_type]
  end

end
