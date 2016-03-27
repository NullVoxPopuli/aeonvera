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

  # slightly different from update, in that it, like create,
  # doesn't take a JSON API formatted set of parameters.
  #
  # This is triggered by:
  # PUT /api/orders/:id/modify
  #
  # If someone wants to change their order after clicking checkout
  # (and thus the order is created), they click the back button to
  # edit can may perform whatever edits.
  #
  # This will get sligtly complicated, as it will need to detect
  # which order line items are being added, which are being removed,
  # and which are being modified.
  def modify
    @model = OrderOperations::Modify.new(current_user, params, params).run
    render_model('order_line_items.line_item')
  end

  def update
    render_model('order_line_items.line_item')
  end

  private

  def update_order_params
    params
      .require(:data)
      .require(:attributes)
      .permit(:payment_method, :checkout_token, :checkout_email, :check_number)
  end

  def order_where_params
    keys = (Order.column_names & params.keys)
    params.slice(*keys).symbolize_keys
  end

  def create_order_params
    params
  end

end
