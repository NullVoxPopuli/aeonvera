class Api::CompetitionsController < APIController

  include SetsEvent

  def index
    render json: @event.competitions, each_serializer: CompetitionSerializer
  end

end
