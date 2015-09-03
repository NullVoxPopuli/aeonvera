class Api::LineItemsController < APIController

  include SetsEvent

  def index
    render json: @event.line_items, each_serializer: LineItemSerializer
  end

end
