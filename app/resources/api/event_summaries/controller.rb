# frozen_string_literal: true

module Api
  class EventSummariesController < APIController
    self.serializer = EventSummarySerializableResource
    self.default_include = 'registrations'

    def index
      search = current_user.hosted_and_collaborated_events.includes(
        registrations: [orders: [order_line_items: [line_item: [:order_line_items]]]],
        orders: [order_line_items: [line_item: [:order_line_items]]]
      ).ransack(params[:q])

      render_jsonapi(model: search.result)
    end

    def show
      model = EventSummaryOperations::Read
              .run(current_user, { event_id: params[:id] })

      render_jsonapi(model: model, options: {
                       expose: { current_user: current_user }
                     })
    end
  end
end
