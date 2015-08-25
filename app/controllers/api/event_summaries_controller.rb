class Api::EventSummariesController < APIController

  def show
    @event = current_user.hosted_events.find(id)
    render json: @event, serializer: EventSummarySerializer
  end

  private

  def id
    params[:event_id] || params[:id]
  end

end
