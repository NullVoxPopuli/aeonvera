# frozen_string_literal: true

module Api
  module OrderLineItemOperations
    class Update < SkinnyControllers::Operation::Base
      def run
        check_allowed!

        model.assign_attributes(params_for_action)
        update_price

        did_change_quantity = model.quantity_changed?
        if model.save && did_change_quantity
          ::Api::OrderOperations::AddAutomaticDiscounts.new(model.order).run
        end

        model
      end

      private

      def update_price
        return unless changed_line_item?

        model.price = model.line_item.current_price
      end

      def changed_line_item?
        model.line_item_id_changed? || model.line_item_type_changed?
      end

      def authorized_via_token?
        model.order.payment_token == params[:payment_token]
      end

      def check_allowed!
        raise SkinnyControllers::DeniedByPolicy unless allowed_to_update_order_line_item?
      end

      def allowed_to_update_order_line_item?
        return true if allowed?

        return false unless authorized_via_token?

        temp_user = OpenStruct.new(id: params[:payment_token])

        policy_class
          .new(temp_user, model)
          .update?
      end
    end
  end
end
