module Api
  class RegisterableEventsController < APIController

    include EventLoader

    before_action :set_event, only: [:show]

    def index
      @events = Event.upcoming
      render json: @events
    end

    def show
      render json: @event
    end

  end
end
