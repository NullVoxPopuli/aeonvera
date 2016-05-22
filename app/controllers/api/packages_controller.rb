class Api::PackagesController < Api::EventResourceController
  private

  def update_package_params
    whitelistable_params do |whitelister|
      whitelister.permit(
        :name, :initial_price, :at_the_door_price,
        :attendee_limit, :expires_at, :requires_track,
        :ignore_pricing_tiers
      )
    end
  end

  def create_package_params
    whitelistable_params do |whitelister|
      whitelister.permit(
        :name, :initial_price, :at_the_door_price,
        :attendee_limit, :expires_at, :requires_track,
        :ignore_pricing_tiers,
        :event_id
      )
    end
  end
end
