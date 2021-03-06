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
      rescue_from AeonVera::Errors::DiscountNotFound, with: :not_found

      rescue_from SkinnyControllers::DeniedByPolicy, with: :denied_by_policy_error
    end
  end
end
