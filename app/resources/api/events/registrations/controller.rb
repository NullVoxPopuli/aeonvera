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
          each_serializer: ::Api::RegistrationSerializer
        )
      end
    end
  end
end
