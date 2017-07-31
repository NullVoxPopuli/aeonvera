# frozen_string_literal: true
module Api
  class UpcomingEventsController < APIController
    def index
      @events = Event.upcoming
      render json: @events, each_serializer: UpcomingEventSerializer, root: :upcoming_event
    end
  end
end
