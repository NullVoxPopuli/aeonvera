# frozen_string_literal: true

module Api
  module OrderOperations
    class SendReceipt < SkinnyControllers::Operation::Base
      def run
        if allowed?
          RegistrationMailer.payment_received_email(order: model).deliver_now
        else
          # TODO: how to sent error to ember?
          raise 'not authorized'
        end
      end
    end
  end
end
