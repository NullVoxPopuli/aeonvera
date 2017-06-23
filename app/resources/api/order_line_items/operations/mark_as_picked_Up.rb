# frozen_string_literal: true
module Api
  module OrderLineItemOperations
    class MarkAsPickedUp < SkinnyControllers::Operation::Base
      def run
        return unless allowed?
        model.update(picked_up_at: Time.now)
        model
      end
    end
  end
end
