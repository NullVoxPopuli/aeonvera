# frozen_string_literal: true
module Api
  module Users
    class RegistrationsController < RegisteredEventsController
      include SkinnyControllers::Diet

      def create
        render_model('housing_request,housing_provision,custom_field_responses')
      end

      def update
        render_model('housing_request,housing_provision,custom_field_responses')
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
