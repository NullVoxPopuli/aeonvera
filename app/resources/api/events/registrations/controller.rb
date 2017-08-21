# frozen_string_literal: true

module Api
  module Events
    class RegistrationsController < ResourceController
      self.serializer = ::Api::Events::RegistrationSerializableResource

      before_filter :must_be_logged_in

      def index
        model = RegistrationOperations::ReadAll
                .run(current_user, params)
                .ransack(params[:q])
                .result

        render_jsonapi(model: model)
      end

      def show
        model = RegistrationOperations::Read.run(current_user, params)

        render_jsonapi(model: model)
      end

      def checkin
        model = RegistrationOperations::Checkin
                .run(current_user, params, checkin_params)

        render_jsonapi(model: model)
      end

      private

      def checkin_params
        params.require(:checked_in_at)
        params
      end

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
