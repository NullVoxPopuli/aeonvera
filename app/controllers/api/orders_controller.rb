class Api::OrdersController < APIController
  include SkinnyControllers::Diet

  def index
    # TODO: How do i differentiate between types of orders?
    # A User should be able to:
    # - view all of their orders
    # - view all orders of an event they are helping organize
    # - view all orders of a community they help run
    # TODO: add those 3 checks to the policy for this action
    search = model.ransack(params[:q]).result(distinct: true)
      .includes(:user, :host, attendance: [:attendee], line_items: [:line_item])
    render json: search, include: params[:include]
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

  def update_order_params
    {
      stripe: stripe_params,
      order: all_order_params
    }
  end

  def order_where_params
    keys = (Order.column_names & params.keys)
    params.slice(*keys).symbolize_keys
  end

  def load_integration
    @integration = (@host || @event).integrations[Integration::STRIPE]
    raise "Stripe not connected to #{@host.name}" unless @integration
  end

  def order_params
    params[:order].try(:permit, :paid_amount, :payment_method, :attendance_id)
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
