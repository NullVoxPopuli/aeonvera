# frozen_string_literal: true

module Api
  class HousingStatsController < APIController
    self.serializer = HousingStatsSerializableResource
    include SetsEvent

    def show
      presenter = HousingStatsPresenter.new(@event)
      render_jsonapi(model: presenter)
    end
  end
end
