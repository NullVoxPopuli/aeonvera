# frozen_string_literal: true
module Api
  class HostedEventsController < APIController
    before_filter :must_be_logged_in

    def index
      @events = current_user.hosted_and_collaborated_events.includes(
        :pricing_tiers, orders: [:order_line_items], registrations: [:attendee]
      )
      render json: @events, each_serializer: HostedEventSerializer, root: :hosted_events
    end

    def show
      @event = current_user.hosted_and_collaborated_events.find(params[:id])
      render json: @event
    end
  end
end
