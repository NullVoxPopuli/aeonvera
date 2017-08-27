module Api
  module Events
    module RegistrationOperations
      class Undestroy < SkinnyControllers::Operation::Default
        include ::HelperOperations::EventManagementPermissionChecks

        def run
          check_allowed!

          registration = Read.run(current_user, params)
          registration.update(deleted_at: nil)

          registration
        end
      end
    end
  end
end
