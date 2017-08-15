# frozen_string_literal: true

module Api
  module OrderOperations
    class RefundPayment < SkinnyControllers::Operation::Base
      def run
        return unless allowed?
        StripeTasks::RefundPayment.run(model, params_for_action)
        StripeTasks::RefreshCharge.run(model)

        model.save

        model
      end
    end

    def model
      @model ||= OrderOperations::Read.new(current_user, params).run
    end
  end
end
