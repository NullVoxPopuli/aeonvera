# frozen_string_literal: true

module Api
  class EventSummariesController < APIController
    self.serializer = EventSummarySerializableResource
    self.default_include = 'registrations'

    def show
      model = EventSummaryOperations::Read
              .run(current_user, { event_id: params[:id] })

      render_jsonapi(model: model, options: {
                       expose: { current_user: current_user }
                     })
    end
  end
end
