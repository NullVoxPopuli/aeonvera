# frozen_string_literal: true

module Api
  module Events
    module RegistrationOperations
      class ReadAll < SkinnyControllers::Operation::Base
        include ::HelperOperations::EventManagementPermissionChecks

        def run
          check_allowed!

          event.registrations
               .includes(
                 :package, :level,
                 :custom_field_responses,
                 :housing_request, :housing_provision,
                 orders: [order_line_items: [:order, :line_item]]
               )
        end
      end
    end
  end
end
