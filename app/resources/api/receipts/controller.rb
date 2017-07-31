# frozen_string_literal: true
module Api
  class ReceiptsController < APIController
    def show
      operation = Operations::Order::SendReceipt.new(current_user, params)
      render json: operation.run
    end
  end
end
