module OrderOperations
  class MarkPaid < SkinnyControllers::Operation::Base
    def run
      order = OrderOperations::Read.new(current_user, params).run

      order.mark_paid!(params_for_action)
      order
    end
  end
end
