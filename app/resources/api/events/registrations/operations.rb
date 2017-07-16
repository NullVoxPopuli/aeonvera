module Api
  module Events
    module RegistrationOperations
      class ReadAll < SkinnyControllers::Operation::Base
        def run
          check_allowed!

          # This can't be scoped to the event,
          # because registrations need to be viewable for users, too
          # TODO: remove attendance, replace with registration
          EventAttendance
            .includes(:package, :level)
            .where(host_id: event.id, host_type: Event.name)
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
          kind = params_for_action[:host_type]

          result = ::Api::EventPolicy
                    .new(current_user, event)
                    .read?(Roles::COLLABORATOR)

          raise SkinnyControllers::DeniedByPolicy, 'You are not a collaborator' unless result
        end
      end
    end
  end
end
