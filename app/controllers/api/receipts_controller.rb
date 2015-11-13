class Api::ReceiptsController < APIController
  def show
    operation = Operations::Order::SendReceipt.new(current_user, params)
    render json: operation.run
  end
end
