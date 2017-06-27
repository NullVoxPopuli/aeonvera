# frozen_string_literal: true
module Api
  module OrderOperations
    class FindByToken < SkinnyControllers::Operation::Base
      def run
        token = params[:token]

        order = Order.find_by_payment_token(token)

        order
      end
    end
  end
end
