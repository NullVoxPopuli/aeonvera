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
        @existing_order_line_item ||= order.order_line_item_for(
          params_for_action[:line_item_id].to_i,
          params_for_action[:line_item_type]
        )
      end

      def order_line_item_params
        @order_line_item_params ||= begin
          attributes = OrderLineItem.column_names
          oli_params = params_for_action.select { |c| attributes.include?(c) }
          oli_params.merge(
            price: price,
            quantity: 1
          )
        end
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
