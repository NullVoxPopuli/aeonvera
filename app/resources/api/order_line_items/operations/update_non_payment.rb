# frozen_string_literal: true

module Api
  module OrderLineItemOperations
    class UpdateNonPayment < SkinnyControllers::Operation::Base
      UPDATEABLE_FIELDS_AFTER_PURCHASE = [
        :dance_orientation, :partner_name,
        :scratch
      ]

      def run
        check_allowed!

        model.assign_attributes(params_for_action)
        model.save
        model
      end

      private


      def check_allowed!
        raise SkinnyControllers::DeniedByPolicy unless allowed_to_update_order_line_item?
      end

      def allowed_to_update_order_line_item?
        return true if allowed?

        false
      end
    end
  end
end
