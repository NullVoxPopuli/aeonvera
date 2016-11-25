module Api
  class IntegrationsController < Api::ResourceController
    before_action :must_be_logged_in
    private

    def create_integration_params
      whitelistable_params(polymorphic: [:owner]) do |whitelister|
        whitelister.permit(
          :authorization_code, :kind, :owner_id, :owner_type
        )
      end
    end
  end
end
