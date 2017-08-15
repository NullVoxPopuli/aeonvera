# frozen_string_literal: true

module Api
  module OrderOperations
    class MarkPaid < SkinnyControllers::Operation::Base
      def run
        order = OrderOperations::Read.new(current_user, params).run
        return unless order

        order.mark_paid!(params_for_action)

        OrderMailer.receipt(for_order: model).deliver_now if order.paid?

        order
      end
    end
  end
end
