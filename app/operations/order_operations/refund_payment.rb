module OrderOperations
  class RefundPayment < SkinnyControllers::Operation::Base
    def run
      order = OrderOperations::Read.new(current_user, params).run
      StripeTasks::RefundPayment.run(order, params_for_action)
      StripeTasks::RefreshCharge.run(order)

      order.save

      order
    end
  end
end
