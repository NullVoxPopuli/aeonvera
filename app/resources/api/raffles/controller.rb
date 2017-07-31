# frozen_string_literal: true
module Api
  class RafflesController < Api::EventResourceController
    def update
      if must_choose_new_winner?
        model.choose_winner!
        # no errors should ever occur when choosing a winner
        # I guess unless there are no tickets purchased...
        # but the UI should hide the button for choosing a winner
        # if no tickets have been purchased
        render json: model
      else
        super
      end
    end

    private

    def must_choose_new_winner?
      whitelistable_params do |whitelister|
        whitelister.permit(:choose_new_winner)
      end
    end

    def update_raffle_params
      whitelistable_params do |whitelister|
        whitelister.permit(:name, :winner_id)
      end
    end

    def create_raffle_params
      whitelistable_params do |whitelister|
        whitelister.permit(:name, :winner_id, :event_id)
      end
    end
  end
end
