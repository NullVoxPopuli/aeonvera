class Api::RaffleTicketsController < Api::ResourceController
  include SkinnyControllers::Diet
  self.model_class = LineItem::RaffleTicket

  def index
    model = operation_class.new(current_user, params, index_params).run
    render json: model, include: params[:include], each_serializer: RaffleTicketSerializer
  end

  def show
    model = operation_class.new(current_user, params, show_params).run
    render json: model, include: params[:include], serializer: RaffleTicketSerializer
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
