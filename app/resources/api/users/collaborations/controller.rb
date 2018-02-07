# frozen_string_literal: true

# This controller only responds to update
module Api
  module Users
    class CollaborationsController < APIController
      self.serializer = CollaborationSerializableResource

      before_action :must_be_logged_in

      def update
        render_jsonapi
      end

      # model will contain errors if something went wrong
      def model
        @model_result ||= accept_operation.run
      end

      def accept_operation
        @accept_operation ||= CollaborationOperations::AcceptInvitation.new(
          current_user,
          params,
          accept_params
        )
      end

      private

      def accept_params
        params.permit(:host_type, :host_id, :token)
      end
    end
  end
end
