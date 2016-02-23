class Api::RafflesController < Api::EventResourceController
  include SkinnyControllers::Diet

  def update
    if must_choose_new_winner?
      model.choose_winner!
      # no errors should ever occur when choosing a winner
      # I guess unless there are no tickets purchased...
      # but the UI should hide the button for choosing a winner
      # if no tickets have been purchased
      render json: model
    else
      super
    end
  end

  private

  def must_choose_new_winner?
    params.dig(:data, :attributes, :choose_new_winner)
  end

  def update_raffle_params
    params
      .require(:data)
      .require(:attributes)
      .permit(:name, :winner_id)
  end

  def create_raffle_params
    create_params_with(update_raffle_params, host: false)
  end

end
