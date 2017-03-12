# frozen_string_literal: true
module Api
  module OrderOperations
    class FindByTokenOrCreate < SkinnyControllers::Operation::Base
      def run
        token = params[:token]

        order = Order.find_by_payment_token(token)
        # TODO: through in the host's current tier
        # TODO: scope creation and finding to the host
        order || Order.create(params_for_action)
      end
    end
  end
end
