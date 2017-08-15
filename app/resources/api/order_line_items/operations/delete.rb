# frozen_string_literal: true

module Api
  module OrderLineItemOperations
    class Delete < SkinnyControllers::Operation::Base
      def run
        return unless allowed_to_delete_order_line_item?
        model.destroy

        ::Api::OrderOperations::AddAutomaticDiscounts.new(model.order.reload).run

        model
      end

      private

      def authorized_via_token?
        model.order.payment_token == params[:payment_token]
      end

      def allowed_to_delete_order_line_item?
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
