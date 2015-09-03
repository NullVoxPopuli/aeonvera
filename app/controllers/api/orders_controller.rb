class Api::OrdersController < APIController

  def index
    @orders = current_user.orders
    render json: @orders,
      each_serializer: OrderSerializer, root: :orders
  end

  def show
    @order = current_user.orders.find(params[:id])
    render json: @order
  end

end
