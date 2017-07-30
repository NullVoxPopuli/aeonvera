# frozen_string_literal: true

module Api
  module Events
    class RegistrationsController < ResourceController
      before_filter :must_be_logged_in

      def index
        model = RegistrationOperations::ReadAll
                .run(current_user, params)
                .ransack(params[:q])
                .result

        render(
          jsonapi:         model,
          # TODO: come up with a way to whitelist includes
          includes:        params[:include],
          each_serializer: ::Api::RegistrationSerializer
        )
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
