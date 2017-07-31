# frozen_string_literal: true
module Api
  module CollaborationOperations
    class ReadAll < SkinnyControllers::Operation::Base
      include CollaborationOperations::Helpers

      def run
        check_allowed!

        host.collaborations
      end

      def check_allowed!
        kind = params_for_action[:host_type]
        policy = "::Api::#{kind}Policy".safe_constantize

        result = policy.new(current_user, host).read?(:admin)

        raise SkinnyControllers::DeniedByPolicy, 'You are not an admin' unless result
      end
    end
  end
end
