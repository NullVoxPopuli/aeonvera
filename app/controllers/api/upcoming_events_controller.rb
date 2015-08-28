class Api::UpcomingEventsController < APIController

  def index
    @events = Event.upcoming
    render json: @events, each_serializer: UpcomingEventSerializer, root: :upcoming_event
  end

end
