# frozen_string_literal: true

module Api
  module OrderLineItemOperations
    class Create < SkinnyControllers::Operation::Base
      FIELDS_REQUIRING_HIGHER_PERMISSIONS = ['picked_up_at'].freeze
      EPHEMERAL_FIELDS = ['discount_code'].freeze

      def run
        @model = discount_code? ? add_discount! : create_line_item!

        check_allowed!
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

        oli = order.order_line_items.build(order_line_item_params)

        if params_for_action[:picked_up_at] && allowed_to_mark_picked_up?(oli)
          oli.picked_up_at = Time.now
        end

        oli
      end

      def existing_order_line_item
        @existing_order_line_item ||= begin
          oli = order.order_line_item_for(
            params_for_action[:line_item_id].to_i,
            params_for_action[:line_item_type]
          )

          size = params_for_action[:size]

          # nil means no match!
          oli && size && size != oli.size ? nil : oli
        end
      end

      def order_line_item_params
        @order_line_item_params ||= begin
          oli_params = params_for_action.reject do |k, _v|
            FIELDS_REQUIRING_HIGHER_PERMISSIONS.include?(k) ||
              EPHEMERAL_FIELDS.include?(k)
          end

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
        return shirt_price if use_shirt_price?
        return line_item.current_price if line_item.respond_to?(:current_price)
        return line_item.price if line_item.respond_to?(:price)

        0
      end

      def shirt_price
        size = params_for_action[:size]
        return unless size

        line_item.price_for_size(size) || line_item.price
      end

      def use_shirt_price?
        params_for_action[:size] && line_item.is_a?(::LineItem::Shirt)
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

      def payment_token
        @payment_token ||= params[:payment_token] || params.dig(:data, :attributes, :payment_token)
      end

      def order
        @order ||= begin
          id = params_for_action[:order_id]

          raise 'Must provide order_id or token' unless id || payment_token

          if current_user
            o = ::Api::OrderOperations::Read.new(
              current_user,
              id: id
            ).run
          end

          o ||= Order.find_by_payment_token(payment_token) if payment_token

          raise "Order not found for id #{id} nor token #{payment_token}, or you do not have permission to access it" unless o

          o
        end
      end

      def check_allowed!
        raise SkinnyControllers::DeniedByPolicy unless allowed_to_create_order_line_item?
      end

      def allowed_to_create_order_line_item?
        return true if allowed?
        return false unless authorized_via_token?

        # If we have a token (no logged in user), we need to create
        # a fake user to use with the policy
        temp_user = OpenStruct.new(id: payment_token)
        policy_class
          .new(temp_user, model)
          .create?
      end

      def allowed_to_mark_picked_up?(order_line_item)
        return false unless current_user

        policy_for(order_line_item).mark_as_picked_up?
      end

      def authorized_via_token?
        order.payment_token == payment_token
      end
    end
  end
end
