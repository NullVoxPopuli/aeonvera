# frozen_string_literal: true

module Api
  module EventSummaryOperations
    class Read < SkinnyControllers::Operation::Base
      include ::HelperOperations::EventManagementPermissionChecks

      def run
        check_allowed!

        Event
          .includes(
            registrations: [orders: [order_line_items: [:line_item]]],
            orders: [order_line_items: [:line_item]])
          .find(event.id)
      end
    end
  end
end
