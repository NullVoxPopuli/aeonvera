# frozen_string_literal: true

module Api
  module Events
    module RegistrationOperations
      class Create < SkinnyControllers::Operation::Default
        include ::HelperOperations::EventManagementPermissionChecks
      end
    end
  end
end
