# frozen_string_literal: true
module Api
  class CustomFieldResponsesController < Api::ResourceController
    private

    def update_custom_field_response_params
      whitelistable_params do |whitelister|
        whitelister.permit(:value)
      end
    end
  end
end
