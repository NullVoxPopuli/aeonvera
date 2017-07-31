# frozen_string_literal: true
module Api
  module OrderOperations
    class RefreshStripe < SkinnyControllers::Operation::Base
      def run
        order = OrderOperations::Read.new(current_user, params).run
        StripeTasks::RefreshCharge.run(order)
        order.save

        order
      end
    end
  end
end
