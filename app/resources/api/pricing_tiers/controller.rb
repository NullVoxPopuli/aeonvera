# frozen_string_literal: true
module Api
  class PricingTiersController < Api::EventResourceController
    self.serializer = PricingTierSerializableResource

    private

    # The fields are named different on teh server than the client
    def update_pricing_tier_params
      whitelistable_params do |whitelister|
        whitelister.permit(
          :date,
          :registrants, :increase_by_dollars
        )
      end
    end

    def create_pricing_tier_params
      whitelistable_params do |whitelister|
        whitelister.permit(
          :event_id,
          :date,
          :registrants, :increase_by_dollars
        )
      end
    end
  end
end
