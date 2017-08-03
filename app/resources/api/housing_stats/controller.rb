# frozen_string_literal: true

module Api
  class HousingStatsController < APIController
    include SetsEvent

    def show
      presenter = HousingStatsPresenter.new(@event)
      render json: success(presenter,
                           class: ::Api::HousingStatsSerializableResource)
    end
  end
end
