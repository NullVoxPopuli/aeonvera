# frozen_string_literal: true
module Api
  module OrderLineItemOperations
    class Delete < SkinnyControllers::Operation::Base
      def run
        return unless allowed?
        model.destroy

        ::Api::OrderOperations::AddAutomaticDiscounts.new(model.order.reload).run

        model
      end
    end
  end
end
