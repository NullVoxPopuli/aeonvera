class Api::OrdersController < APIController
  include SkinnyControllers::Diet
  before_filter :must_be_logged_in, only: [:index]

  def index
    render json: model, include: params[:include]
  end

  def show
    render_model(params[:include])
  end

  def create
    render_model('order_line_items.line_item')
  end

  def update
    render_model('order_line_items.line_item')
  end

  def destroy
    render json: model
  end

  def refresh_stripe
    # op = OrderOperations::Read.new(current_user, params)
    # order = op.run
    order = Order.find(params[:id])
    StripeTasks::RefreshCharge.run(order)
    order.save
    render json: order
  end

  # expects two parameters
  # - refund_type
  # - partial_refund_amount
  def refund_payment
    order = Order.find(params[:id])
    StripeTasks::RefundPayment.run(order, refund_params)
    order.save
    render json: order
  end

  private

  def refund_params
    params.permit(:refund_type, :partial_refund_amount)
  end

  def deserialized_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(
      params,
      embedded: [:order_line_items],
      polymorphic: [:line_item, :host])
  end

  def create_order_params
    whitelister = ActionController::Parameters.new(deserialized_params)
    whitelisted = whitelister.permit(
      :attendance_id, :host_id, :host_type,
      :pricing_tier_id,
      :payment_method,
      :user_email, :user_name,
      :payment_token,

      order_line_items_attributes: [
        :line_item_id, :line_item_type,
        :price, :quantity,
        :partner_name, :dance_orientation, :size
      ]
    )

    EmberTypeInflector.to_rails(whitelisted)
  end

  def update_order_params
    whitelister = ActionController::Parameters.new(deserialized_params)
    whitelisted = whitelister.permit(
      :attendance_id, :host_id, :host_type, :payment_method,
      :user_email, :user_name,

      # specifically for payment
      # the presence of these keys determines if we are paying or
      # just updating the order / order-line-item data
      :payment_method, :checkout_token, :checkout_email, :check_number,

      # This is for when a user isn't logged in.
      :payment_token
    )

    EmberTypeInflector.to_rails(whitelisted)
  end

  # TODO: is this used anywhere?
  def order_where_params
    keys = (Order.column_names & params.keys)
    params.slice(*keys).symbolize_keys
  end
end
