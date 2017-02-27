# frozen_string_literal: true
module Api
  class RegisteredEventsController < APIController
    before_filter :must_be_logged_in

    def index
      attendances = current_user.event_attendances
      render json: attendances, each_serializer: RegisteredEventSerializer
    end

    def show
      attendance = current_user.attendances.find(params[:id])
      render json: attendance, serializer: RegisteredEventSerializer
    end
  end
end
