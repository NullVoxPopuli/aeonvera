class Api::RafflesController < Api::EventResourceController

  private

  def update_raffle_params
    params
      .require(:data)
      .require(:attributes)
      .permit(:name, :winner_id)
  end

  def create_raffle_params
    create_params_with(update_raffle_params)
  end

end
