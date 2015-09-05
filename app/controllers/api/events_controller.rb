class Api::EventsController < APIController
  include EventLoader
  before_action :set_event, only: [:show, :index]

  def index; show; end
  def show
    render json: @event, each_serializer: EventSerializer
  end

  private

  def id
    params[:event_id] || params[:id]
  end

end
