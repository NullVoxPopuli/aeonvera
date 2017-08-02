# frozen_string_literal: true

module Api
  module Events
    class RegistrationsController < ResourceController
      before_filter :must_be_logged_in

      self.serializer = ::Api::Events::RegistrationSerializer

      def index
        model = RegistrationOperations::ReadAll
                .run(current_user, params)
                .ransack(params[:q])
                .result

        hash = success_renderer
               .render(model,
                       include: params[:include],
                       class: ::Api::Events::RegistrationSerializableResource)

        render json: hash
      end

      def show
        model = RegistrationOperations::Read.run(current_user, params)

        hash = success_renderer
               .render(model,
                       include: params[:include],
                       class: ::Api::Events::RegistrationSerializableResource)

        render json: hash
      end

      def checkin
        render_model
      end

      private

      def resource_params
        whitelistable_params(polymorphic: [:host]) do |w|
          w.permit(
            :attendee_first_name, :attendee_last_name,
            :city, :state, :phone_number,
            :interested_in_volunteering,
            :dance_orientation,
            :host_id, :host_type,
            :level_id
          )
        end
      end
    end
  end
end
