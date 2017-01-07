# frozen_string_literal: true
module Api
  module OrderOperations
    class ReadAll < SkinnyControllers::Operation::Base
      def run
        search = orders
        return search if search.empty?

        # for the sake of speed, and the garbage collector,
        # create one policy, and re-use it for all the orders
        policy = OrderPolicy.new(current_user, nil)

        # instead of relying on policy.read_all?,
        # we need to check each order ourselves, because read_all? only
        # returns a boolean if you can read everything.
        # we don't care if there are things we can't read, we just want
        # the things we can read.
        @model = search.select do |order|
          policy.object = order
          policy.read?
        end
      end

      def orders
        return model if model.is_a?(Array)
        model.search(params[:q]).result(distinct: true)
             .includes(
               :user,
               :host,
               attendance: [:attendee], order_line_items: [:line_item]
             )
      end
    end
  end
end