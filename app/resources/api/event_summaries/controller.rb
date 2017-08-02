# frozen_string_literal: true

module Api
  class EventSummariesController < APIController
    def show
      model = EventSummaryOperations::Read
              .run(current_user, { event_id: params[:id] })
      hash = success_renderer
             .render(model,
                     include: 'registrations',
                     expose: { current_user: current_user },
                     class: EventSummarySerializableResource)

      render json: hash
    end
  end
end
