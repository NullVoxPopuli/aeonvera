# frozen_string_literal: true
module Controllers
  module ErrorHandlers
    extend ActiveSupport::Concern

    included do
      rescue_from StandardError, with: :server_error

      rescue_from ActionController::RoutingError, with: :routing_error
      rescue_from ActionController::ParameterMissing, with: :client_error

      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      rescue_from AeonVera::Errors::BeforeHookFailed, with: :client_error

      # TODO: Change this to a 401 (instead of 404)
      rescue_from SkinnyControllers::DeniedByPolicy, with: :not_found
    end
  end
end
