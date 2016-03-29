class Api::HostedEventsController < APIController
  before_filter :must_be_logged_in

  def index
    @events = current_user.hosted_and_collaborated_events
    render json: @events, each_serializer: HostedEventSerializer, root: :hosted_events
  end

  def show
    @event = current_user.hosted_events.find(params[:id])
    render json: @event
  end

end
