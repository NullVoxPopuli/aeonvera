# frozen_string_literal: true

module Api
  module OrderOperations
    class Delete < SkinnyControllers::Operation::Base
      def run
        return unless allowed_to_delete_order?
        model.destroy

        model
      end

      private

      def authorized_via_token?
        model.payment_token == params[:payment_token]
      end

      def allowed_to_delete_order?
        return true if allowed?

        return false unless authorized_via_token?

        temp_user = OpenStruct.new(id: params[:payment_token])

        policy_class
          .new(temp_user, model)
          .delete?
      end
    end
  end
end
