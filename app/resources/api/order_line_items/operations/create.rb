# frozen_string_literal: true
module Api
  module OrderLineItemOperations
    class Create < SkinnyControllers::Operation::Base
      def run
        check_params!
        order = OrderOperations::Read.new(current_user, id: params_for_action[:order_id]).run

        @model = order.order_line_items.build(order_line_item_params)

        return unless allowed?
        @model.save

        # TODO: check for automatic discounts.
        # TODO: check for discount restrictions
        @model
      end

      def order_line_item_params
        @order_line_item_params ||= params_for_action.merge(
          price: price,
          quantity: 1
        )
      end

      def price
        line_item.current_price
      end

      def line_item
        # Does type matter here? are there multiple tables?
        @line_item ||= LineItem.find(params_for_action[:line_item_id])
      end

      def check_params!
        params_for_action.fetch(:order_id)
        params_for_action.fetch(:line_item_id)
        params_for_action.fetch(:line_item_type)
      end
    end
  end
end
