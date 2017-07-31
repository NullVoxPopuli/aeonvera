# frozen_string_literal: true
module Api
  class EventSummariesController < APIController
    include SetsEvent

    def show
      render json: @event,
             serializer: EventSummarySerializer,
             root: :event_summaries,
             include: params[:include]
    end
end
end
