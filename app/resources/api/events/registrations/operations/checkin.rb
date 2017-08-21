# frozen_string_literal: true

module Api
  module Events
    module RegistrationOperations
      class Checkin < SkinnyControllers::Operation::Base
        include ::HelperOperations::EventManagementPermissionChecks

        def run
          check_allowed!

          registration = Read.run(current_user, params)

          checked_in_at = params_for_action[:checked_in_at]
          registration.update(checked_in_at: checked_in_at)

          registration
        end
      end
    end
  end
end
