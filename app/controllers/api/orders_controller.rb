class Api::OrdersController < APIController
  include SkinnyControllers::Diet
  include HostLoader
  include StripeCharge

  before_action :find_host_params, only: [:create, :update]
  before_action :sets_host, only: [:create, :update]
  before_action :load_integration, only: [:update, :create]

  def index
    render json: model
  end

  def show
    render json: model
  end

  def create
    render json: model
  end

  def update
    render json: model
  end

  private

  def order_where_params
    keys = (Order.column_names & params.keys)
    params.slice(*keys).symbolize_keys
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
