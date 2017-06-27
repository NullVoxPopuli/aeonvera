# frozen_string_literal: true

module Api
  module OrderOperations
    class Read < SkinnyControllers::Operation::Base
      def run
        model if allowed_to_read_order?
      end

      private

      def authorized_via_token?
        model.payment_token == params[:payment_token]
      end

      def allowed_to_read_order?
        return true if allowed?

        return false unless authorized_via_token?

        temp_user = OpenStruct.new(id: params[:payment_token])

        policy_class
          .new(temp_user, model)
          .read?
      end
    end
  end
end
