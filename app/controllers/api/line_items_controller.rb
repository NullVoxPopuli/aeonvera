class Api::LineItemsController < APIController
  include EventLoader

  before_action :set_event, only: [:index]



  def index
    render json: resource_proxy, each_serializer: LineItemSerializer, include: params[:include]
  end

  def show
    operation = Operations::LineItem::Read.new(current_user, params)
    render json: operation.run
  end

  private

  def resource_proxy
    # current_user.hosted_and_collaborated_events
    @event.line_items
  end

end
