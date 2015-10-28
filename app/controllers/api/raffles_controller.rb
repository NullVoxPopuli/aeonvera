class Api::RafflesController < APIController

  include SetsEvent

  def index
    render json: @event.raffles, include: params[:include]
  end

end
