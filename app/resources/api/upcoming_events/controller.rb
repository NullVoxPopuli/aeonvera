# frozen_string_literal: true

module Api
  class UpcomingEventsController < APIController
    self.serializer = UpcomingEventSerializableResource

    def index
      render_jsonapi(model: Event.upcoming)
    end
  end
end
