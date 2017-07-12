# frozen_string_literal: true
module Api
  class CompetitionsController < Api::EventResourceController
    def index
      render json: model, include: 'order_line_items.order.attendance'
    end

    private

    def update_competition_params
      whitelistable_params do |whitelister|
        whitelister.permit(
          :name, :initial_price, :at_the_door_price, :kind,
          :description, :nonregisterable
        )
      end
    end

    def create_competition_params
      whitelistable_params do |whitelister|
        whitelister.permit(
          :name, :initial_price,
          :at_the_door_price, :kind, :event_id,
          :description, :nonregisterable
        )
      end
    end
  end
end
