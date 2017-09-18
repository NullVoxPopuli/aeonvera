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

        respond_to do |format|
          format.json { render_jsonapi(model: model) }
          format.csv { send_csv(model) }
        end
      end

      def update
        model = RegistrationOperations::Update
                .run(current_user, params, resource_params)

        render_jsonapi(model: model)
      end

      def deleted
        model = RegistrationOperations::ReadAll
                .run(current_user, params)
                .only_deleted
                .ransack(params[:q])
                .result

        render_jsonapi(model: model)
      end

      def transfer
        model = RegistrationOperations::Transfer
                .run(current_user, params, transfer_params)

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

      def uncheckin
        model = RegistrationOperations::Uncheckin
                .run(current_user, params)

        render_jsonapi(model: model)
      end

      def undestroy
        model = RegistrationOperations::Undestroy
                .run(current_user, params)

        render_jsonapi(model: model)
      end

      private

      def transfer_params
        whitelistable_params do |w|
          w.permit(
            :transferred_to_email,
            :transferred_to_first_name,
            :transferred_to_last_name,
            :transferred_to_year,
            :transfer_reason
          )
        end
      end

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
            :is_attending,
            :dance_orientation,
            :host_id, :host_type,
            :level_id
          )
        end
      end
    end
  end
end
