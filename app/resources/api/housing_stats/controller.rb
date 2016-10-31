module Api
  class HousingStatsController < APIController
    include SetsEvent

    def show
      render json: @event, serializer: HousingStatsSerializer
    end
  end
end
