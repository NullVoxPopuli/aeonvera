# frozen_string_literal: true

module Api
  module OrderLineItemsOperations
    class ApplyDiscount
      attr_reader :discount_code, :order

      def initialize(order, discount_code)
        @order = order
        @discount_code = discount_code
      end

      def run
        # Discount can't be applied twice
        return if existing_discount

        # TODO: add logic for percentage discoorder_line_item_unt
        order.order_line_items.build(
          quantity: 1,
          price: 0 - discount.value,
          line_item: discount
        )
      end

      private

      def discount
        discount = Discount.find_by_code(discount_code)
        raise AeonVera::Errors::DiscountNotFound, 'Discount not found' unless discount

        discount
      end

      def existing_discount
        @existing_discount ||= order.order_line_item_for_item(discount)
      end
    end
  end
end
