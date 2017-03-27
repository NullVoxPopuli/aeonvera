# frozen_string_literal: true
module Api
  module OrderLineItemOperations
    class Create < SkinnyControllers::Operation::Base
      def run
        check_params!

        @model = build_model
        return unless allowed?
        @model.save

        # Check if automatic discounts need to be added.
        # (Like a MembershipDiscount)
        ::Api::OrderOperations::AddAutomaticDiscounts.new(order).run

        # TODO: check for discount restrictions
        @model
      end

      private

      def build_model
        item = existing_order_line_item

        if item
          item.quantity = item.quantity + 1
          return item
        end

        order.order_line_items.build(order_line_item_params)
      end

      def existing_order_line_item
        @existing_order_line_item ||= order.order_line_item_for(
          params_for_action[:line_item_id].to_i,
          params_for_action[:line_item_type]
        )
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
        @line_item ||= ::LineItem.find(params_for_action[:line_item_id])
      end

      def check_params!
        params_for_action.fetch(:order_id)
        params_for_action.fetch(:line_item_id)
        params_for_action.fetch(:line_item_type)
      end

      def order
        @order ||= ::Api::OrderOperations::Read.new(current_user, id: params_for_action[:order_id]).run
      end

    end
  end
end
