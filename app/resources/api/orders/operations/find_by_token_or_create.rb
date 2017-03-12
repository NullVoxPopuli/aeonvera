# frozen_string_literal: true
module Api
  module OrderOperations
    class FindByTokenOrCreate < SkinnyControllers::Operation::Base
      def run
        token = params[:token]

        order = Order.find_by_payment_token(token)
        order || Order.create(params_for_action)
      end
    end
  end
end
