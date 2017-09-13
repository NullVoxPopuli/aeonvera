# frozen_string_literal: true

module Api
  module Events
    module RegistrationOperations
      # NOTE: the to_first/last_name attributes are fake
      #       they make sense from a UI perspective, but
      #       for ease of data representation, these fields
      #       become the new attendee_first/last_name
      #
      # TODO: send an email to transferred_to_email about their
      #       newly recived / transferred pass, and have them
      #       confirm that email, which will allow us to set
      #       the transferred_from_user_id to the current attendee_id
      #       and update the attendee_id to the person who just
      #       confirmed the email.
      class Transfer < SkinnyControllers::Operation::Base
        include ::HelperOperations::EventManagementPermissionChecks

        def run
          check_allowed!

          to_year if transfer_to_year?
          to_person if transfer_to_person?

          registration.transfer_reason = params_for_action[:transfer_reason]
          registration.transferred_at = Time.now

          registration.save!

          registration
        end

        private

        def registration
          @registration ||= Read.run(current_user, params)
        end

        def transfer_to_person?
          !transfer_to_year?
        end

        def transfer_to_year?
          params_for_action[:transferred_to_year].present?
        end

        def to_year
          registration.transferred_to_year = params_for_action[:transferred_to_year]
        end

        def to_person
          transferred_to_first_name,
          transferred_to_last_name = params_for_action
                                     .values_at(
                                       :transferred_to_first_name,
                                       :transferred_to_last_name
                                     )

          # Store the name of the original registrant
          registration.transferred_from_first_name = registration.attendee_first_name
          registration.transferred_from_last_name = registration.attendee_last_name

          # Set the new attendee name
          registration.attendee_first_name = transferred_to_first_name
          registration.attendee_last_name = transferred_to_last_name

          registration.transferred_to_email = params_for_action[:transferred_to_email]

          # TODO: kickoff the email confirmation here
        end
      end
    end
  end
end
