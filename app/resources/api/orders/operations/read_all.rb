# frozen_string_literal: true

module Api
  module OrderOperations
    class ReadAll < SkinnyControllers::Operation::Base
      include HelperOperations::Helpers

      def run
        return find_one if params[:id]

        find_many
      end

      private

      def find_one
        OrderOperations::Read.run(current_user, params)
      end

      def find_many
        search = model
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

      def model
        return scope if scope.is_a?(Array)

        scope.ransack(params[:q]).result(distinct: true)
             .includes(
               :user,
               :host,
               registration: [:attendee], order_line_items: [:line_item]
             )
      end

      def scope
        return host_scope if requesting_from_host?

        current_user.orders
      end

      def requesting_from_host?
        params[:host_id] && params[:host_type]
      end

      def host_scope
        host.orders
      end

      def host
        host_from_params(params)
      end
    end
  end
end
