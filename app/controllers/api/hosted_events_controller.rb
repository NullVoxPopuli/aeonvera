class Api::HostedEventsController < APIController

  def index
    @events = current_user.hosted_events
    render json: @events
  end

  def show
    @event = current_user.hosted_events.find(params[:id])
    render json: @event
  end

end
