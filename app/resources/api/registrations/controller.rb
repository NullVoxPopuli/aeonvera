# frozen_string_literal: true

module Api
  class RegistrationsController < APIController
    def index
      search = current_user.attendances.ransack(params[:q])
      @attendances = search.result

      render json: @attendances,
             include: params[:include],
             each_serializer: RegistrationSummarySerializer
    end

    def show
      @attendance = current_user.attendances.find(params[:id])
      render json: @attendance
    end
  end
end
