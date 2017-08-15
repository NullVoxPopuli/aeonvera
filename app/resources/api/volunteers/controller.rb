# frozen_string_literal: true

module Api
  class VolunteersController < APIController
    include SetsEvent

    def index
      render json: @event.registrations.volunteering, each_serializer: VolunteerSerializer
    end
  end
end
