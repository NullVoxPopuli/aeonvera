# frozen_string_literal: true

module Api
  module CollaborationOperations
    module Helpers
      def parent_resource
        host
      end

      def association_name_for_parent_resource
        :collaborations
      end

      def collaboration
        return @collaboration if @collaboration

        # just something to keep track of errors for the UI
        @collaboration = Collaboration.new
        @collaboration.errors.add(:base, 'event or organization not found') unless host
        @collaboration.collaborated = host

        @collaboration
      end

      def host
        @host ||= find_host
      end

      def find_host
        id, kind = params_for_action.values_at(:host_id, :host_type)
        host_op_class = "::Api::#{kind}Operations::Read".safe_constantize

        host_op_class&.call(current_user, { id: id })
      end
    end
  end
end
