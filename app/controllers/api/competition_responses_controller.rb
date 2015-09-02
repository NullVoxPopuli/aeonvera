class Api::CompetitionResponsesController < APIController

  include SetsEvent

  def index
    render json: @event.competition_responses
  end

  def show
    render json: CompetitionResponse.find(params[:id])
  end

end
