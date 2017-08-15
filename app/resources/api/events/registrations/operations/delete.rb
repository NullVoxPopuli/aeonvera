# frozen_string_literal: true

module Api
  module Events
    module RegistrationOperations
      class Delete < SkinnyControllers::Operation::Default
        include ::HelperOperations::EventManagementPermissionChecks
      end
    end
  end
end
