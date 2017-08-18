# frozen_string_literal: true

module Api
  class VolunteersController < APIController
    self.serializer = VolunteerSerializableResource

    include SetsEvent

    def index
      render_jsonapi(model: @event.registrations.volunteering)
    end
  end
end
