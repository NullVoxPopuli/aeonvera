class Api::LevelsController < APIController
  include SetsEvent
  include LazyCrud

  set_resource_parent Event

  def index
    @levels = resource_proxy
    render json: @levels, include: params[:include]
  end

  private

  def resource_proxy
    # current_user.hosted_and_collaborated_events
    current_user.hosted_events.find(params[:event_id]).levels
  end
end
