# frozen_string_literal: true

module Api
  module Events
    module RegistrationOperations
      class Update < SkinnyControllers::Operation::Default
        include ::HelperOperations::EventManagementPermissionChecks

        def run
          check_allowed!

          registration = Read.run(current_user, params)
          registration.update(params_for_action)
          registration
        end
      end
    end
  end
end
