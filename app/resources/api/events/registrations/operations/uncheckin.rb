# frozen_string_literal: true

module Api
  module Events
    module RegistrationOperations
      class Uncheckin < SkinnyControllers::Operation::Base
        include ::HelperOperations::EventManagementPermissionChecks

        def run
          check_allowed!

          registration = Read.run(current_user, params)
          registration.update(checked_in_at: nil)

          registration
        end
      end
    end
  end
end
