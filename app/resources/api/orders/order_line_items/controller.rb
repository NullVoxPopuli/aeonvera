# frozen_string_literal: true

module Api
  module Orders
    class OrderLineItemsController < Api::ResourceController
      def index
        render jsonapi: order.order_line_items
      end

      private

      def order
        @order ||= begin
          order_id = params.require(:order_id)
          OrderOperations::Read.new(current_user, id: order_id).run
        end
      end
    end
  end
end
