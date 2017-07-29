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

      def create_registration_params
        whitelistable_params do |whitelister|
          whitelister.permit(
            # Attendance Attributes
            :phone_number, :interested_in_volunteering,
            :city, :state, :zip,
            :dance_orientation,
            # To be deleted - these are used for searching for an existing user
            # and then creating a new user if one doesn't exist
            :attendee_email, :attendee_name,

            # Relationships
            :level_id, :pricing_tier_id,
            :host_id, :host_type
          )
        end
      end

      def update_registration_params
        whitelistable_params do |whitelister|
          whitelister.permit(
            # Attendance Attributes
            :phone_number, :interested_in_volunteering,
            :city, :state, :zip,
            :dance_orientation,

            # Relationships
            :level_id
          )
        end
      end
    end
  end
end
