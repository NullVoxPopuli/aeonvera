class Api::LineItemsController < APIController
  include SetsEvent

  def index
    render json: resource_proxy, each_serializer: LineItemSerializer, include: params[:include]
  end

  private

  def resource_proxy
    # current_user.hosted_and_collaborated_events
    @event.line_items
  end

end
