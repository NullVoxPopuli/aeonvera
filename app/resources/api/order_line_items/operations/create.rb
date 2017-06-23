# frozen_string_literal: true
module Api
  module OrderLineItemOperations
    class Create < SkinnyControllers::Operation::Base
      def run
        @model = discount_code? ? add_discount! : create_line_item!

        return unless allowed?
        @model.save

        # Check if automatic discounts need to be added.
        # (Like a MembershipDiscount)
        ::Api::OrderOperations::AddAutomaticDiscounts.new(order).run

        # TODO: check for discount restrictions
        @model
      end

      private

      def add_discount!
        code = ActiveModelSerializers::Deserialization.jsonapi_parse(params)[:discount_code]

        operation = ::Api::OrderLineItemsOperations::ApplyDiscount.new(
          order,
          code
        )

        operation.run
      end

      def discount_code?
        params_for_action[:discount_code]
      end

      def create_line_item!
        check_params!

        # operation = ::Api::OrderLineItemsOperations::CreateOrderLineItem.new(
        #   order,
        #   line_item,
        #   quantity: order_line_item_params[:quantity],
        #   price: order_line_item_params[:price]
        # )
        #
        # operation.run
        build_model
      end

      def build_model
        item = existing_order_line_item

        if item
          item.quantity = item.quantity + 1
          return item
        end

        order.order_line_items.build(order_line_item_params)
      end

      def existing_order_line_item
        @existing_order_line_item ||= begin
          oli = order.order_line_item_for(
            params_for_action[:line_item_id].to_i,
            params_for_action[:line_item_type]
          )

          size = params_for_action[:size]

          # nil means no match!
          (oli && size && size != oli.size) ? nil : oli
        end
      end

      def order_line_item_params
        @order_line_item_params ||= begin
          attributes = OrderLineItem.column_names
          oli_params = params_for_action.select { |c| attributes.include?(c) }
          given_quantity = oli_params[:quantity]
          quantity = given_quantity.to_i > 0 ? given_quantity : 1

          oli_params.merge(
            price: price,
            quantity: quantity
          )
        end
      end

      def price
        return 0 - line_item.value if line_item.is_a?(Discount)
        return line_item.current_price if line_item.respond_to?(:current_price)
        return line_item.price if line_item.respond_to?(:price)

        0
      end

      def line_item
        # Not everything purchasable is a line item.
        # TODO: consider making everything a line item?
        @line_item ||= begin
          klass = params_for_action[:line_item_type].safe_constantize || ::LineItem
          klass.find(params_for_action[:line_item_id])
        end
      end

      def check_params!
        params_for_action.fetch(:order_id)
        params_for_action.fetch(:line_item_id)
        params_for_action.fetch(:line_item_type)
      end

      def order
        @order ||= begin
          raise 'Must provide order_id' unless params_for_action[:order_id]

          ::Api::OrderOperations::Read.new(
            current_user,
            id: params_for_action[:order_id]
          ).run
        end
      end
    end
  end
end
