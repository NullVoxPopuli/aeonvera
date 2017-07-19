# frozen_string_literal: true
module Api
  module Users
    class RegisteredEventsController < APIController
      before_filter :must_be_logged_in

      def index
        registrations = current_user
                        .event_attendances
                        .includes(orders: [:order_line_items])

        render(
          jsonapi: registrations,
          each_serializer: RegisteredEventSerializer
        )
      end

      def show
        registration = current_user
                       .attendances
                       .includes(orders: [:order_line_items])
                       .find(params[:id])

        render(
          jsonapi: registration,
          serializer: RegisteredEventSerializer
        )
      end
    end
  end
end
