# frozen_string_literal: true
module Api
  module Events
    module RegistrationOperations
      class ReadAll < SkinnyControllers::Operation::Base
        def run
          check_allowed!

          # This can't be scoped to the event,
          # because registrations need to be viewable for users, too
          # TODO: remove registration, replace with registration
          Registration
            .includes(
              :package, :level,
              :custom_field_responses,
              :housing_request, :housing_provision,
              orders: [order_line_items: [:order, :line_item]]
            )
            .where(host_id: event.id)
        end

        private

        def event
          @event ||= find_event
        end

        def find_event
          id = params_for_action[:event_id]

          Event.find(id)
        end

        def check_allowed!
          result = ::Api::EventPolicy
                   .new(current_user, event)
                   .read?(Roles::COLLABORATOR)

          raise SkinnyControllers::DeniedByPolicy, 'You are not a collaborator' unless result
        end
      end

      class Update < SkinnyControllers::Operation::Base
        def run
          model.update(params_for_action) if allowed?
          model
        end
      end

      class Checkin < Update
        # TODO: only event collaborators can check someone in
      end
    end
  end
end
