class Api::RaffleTicketsController < Api::ResourceController
  include SkinnyControllers::Diet

  def index
    model = operation_class.new(current_user, params, index_params).run
    render json: model, include: params[:include]
  end

  def show
    model = operation_class.new(current_user, params, show_params).run
    render json: model, include: params[:include]
  end

  private

  def index_params
    params[:filter] ? params : params.require(:raffle_id)
  end

  def show_params
    params.require(:raffle_id)
  end

  def update_params

  end

  def create_params

  end

end
