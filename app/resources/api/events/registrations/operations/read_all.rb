# frozen_string_literal: true

module Api
  module Events
    module RegistrationOperations
      class ReadAll < SkinnyControllers::Operation::Base
        include ::HelperOperations::EventManagementPermissionChecks

        def run
          check_allowed!

          # This can't be scoped to the event,
          # because registrations need to be viewable for users, too
          # TODO: remove registration, replace with registration
          Registration
            .includes(
              :package, :level,
              :custom_field_responses,
              :housing_request, :housing_provision,
              orders: [order_line_items: [:order, :line_item]]
            )
            .where(host_id: event.id)
        end
      end
    end
  end
end
