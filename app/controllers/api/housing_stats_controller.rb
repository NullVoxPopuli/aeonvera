class Api::HousingStatsController < APIController
  include SetsEvent

  def show
    render json: @event, serializer: HousingStatsSerializer
  end
end
