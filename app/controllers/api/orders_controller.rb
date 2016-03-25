class Api::OrdersController < APIController
  include SkinnyControllers::Diet
  before_filter :must_be_logged_in, only: [:index]

  def index
    render json: model, include: params[:include]
  end

  def show
    render json: model, include: params[:include]
  end

  def create
    if model.errors.present?
      render json: model.errors.to_json_api, status: 422
    else
      render json: model, include: 'order_line_items.line_item'
    end
  end

  def update
    if model.errors.present?
      render json: model.errors.to_json_api, status: 422
    else
      render json: model, include: 'order_line_items.line_item'
    end
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
