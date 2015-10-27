class Api::EventSummariesController < APIController

  include SetsEvent

  def show
    render json: @event, serializer: EventSummarySerializer, root: :event_summaries, include: params[:include]
  end


end
