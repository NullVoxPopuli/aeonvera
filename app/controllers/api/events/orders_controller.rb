class Api::Events::OrdersController < APIController

  include SetsEvent

  def index
    render json: @event.orders, each_serializer: OrderSerializer
  end

end
