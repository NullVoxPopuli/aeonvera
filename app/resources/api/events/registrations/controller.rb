# frozen_string_literal: true
module Api
  module Events
    class RegistrationsController < ResourceController
      def index
        model = RegistrationOperations::ReadAll
                .run(current_user, params)
                .ransack(params[:q])
                .result

        render(
          jsonapi: model,
          # TODO: come up with a way to whitelist includes
          includes: params[:include],
          each_serializer: ::Api::RegistrationSerializer
        )
      end
    end
  end
end
