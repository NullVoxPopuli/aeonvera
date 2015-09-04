class Api::ShirtsController < APIController

  include SetsEvent

  def index
    render json: @event.shirts, each_serializer: ShirtSerializer, root: 'shirts'
  end

end
