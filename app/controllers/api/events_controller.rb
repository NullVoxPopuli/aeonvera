class Api::EventsController < APIController

  def index; show; end
  def show
    @event = current_user.hosted_events.find(id)
    render json: @event, each_serializer: EventSerializer
  end

  private

  def id
    params[:event_id] || params[:id]
  end

end
