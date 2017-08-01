# frozen_string_literal: true

module Api
  module Users
    class RegistrationsController < APIController
      include SkinnyControllers::Diet

      before_filter :must_be_logged_in

      def create
        render_model('housing_request,housing_provision,custom_field_responses')
      end

      def update
        params[:fields] = { registration: {} }
        render_model('housing_request,housing_provision,custom_field_responses')
      end

      def index
        model = current_user
                .registrations
                .ransack(params[:q])
                .result

        render(
          jsonapi:         model,
          # TODO: come up with a way to whitelist includes
          includes:        [orders: [:order_line_items]],
          each_serializer: ::Api::Users::RegistrationSerializer
        )
      end

      def show
        registration = current_user
                       .registrations
                       .includes(orders: [:order_line_items])
                       .find(params[:id])

        render(
          jsonapi: registration,
          serializer: ::Api::Users::RegistrationSerializer
        )
      end

      def destroy
        @model = model

        head :no_content
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
