# frozen_string_literal: true
module Api
  module OrderLineItemOperations
    class Update < SkinnyControllers::Operation::Base
      def run
        model.assign_attributes(params_for_action)

        did_change_quantity = model.quantity_changed?
        if model.save && did_change_quantity
          ::Api::OrderOperations::AddAutomaticDiscounts.new(model.order).run
        end

        model
      end
    end
  end
end
