# frozen_string_literal: true

module Api
  class HostedEventsController < APIController
    self.serializer = HostedEventSerializableResource

    before_filter :must_be_logged_in

    def index
      @events = current_user.hosted_and_collaborated_events.includes(
        :registrations,
        :pricing_tiers, orders: [:order_line_items]
      )

      render_jsonapi(model: @events, options: {
                       expose: { current_user: current_user }
                     })
    end

    def show
      @event = current_user.hosted_and_collaborated_events.find(params[:id])

      render_jsonapi(model: @event)
    end
  end
end
