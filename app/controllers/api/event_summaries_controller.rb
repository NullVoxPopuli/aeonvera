class Api::EventSummariesController < APIController

  include SetsEvent

  def show
    render json: @event, serializer: EventSummarySerializer, root: :event_summaries
  end


end
