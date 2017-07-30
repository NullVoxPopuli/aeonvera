# frozen_string_literal: true

module HelperOperations
  module EventManagementPermissionChecks
    protected

    def check_allowed!
      result = ::Api::EventPolicy
               .new(current_user, event)
               .read?(Roles::COLLABORATOR)

      raise SkinnyControllers::DeniedByPolicy, 'You are not a collaborator' unless result
    end

    def event
      @event ||= find_event
    end

    def find_event
      id = params_for_action[:event_id] || params[:event_id]

      Event.find(id)
    end
  end
end
