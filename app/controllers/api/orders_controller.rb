class Api::OrdersController < APIController
  include SkinnyControllers::Diet

  def index
    render json: model, include: params[:include]
  end

  def show
    render json: model
  end

  def create
    if model.errors.present?
      render json: model.errors.to_json_api, status: 422
    else
      render json: model
    end
  end

  def update
    render json: model
  end

  private

  def update_order_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, polymorphic: [:host])
  end

  def order_where_params
    keys = (Order.column_names & params.keys)
    params.slice(*keys).symbolize_keys
  end

  def create_order_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, polymorphic: [:host])
  end

  def order_params
    params[:order].try(:permit, :paid_amount, :payment_method, :attendance_id)
  end

end
