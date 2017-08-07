# frozen_string_literal: true
module Api
  class CustomFieldResponsesController < Api::ResourceController
    self.serializer = CustomFieldResponseSerializableResource

    private

    def update_custom_field_response_params
      whitelistable_params do |whitelister|
        whitelister.permit(:value)
      end
    end
  end
end
