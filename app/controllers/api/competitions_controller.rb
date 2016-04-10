class Api::CompetitionsController < Api::EventResourceController

  def index
    render json: model, include: 'order_line_items.order.attendance'
  end

  private

  def update_competition_params
    result = ActiveModelSerializers::Deserialization
      .jsonapi_parse(params, only: [
        :name, :initial_price,
        :at_the_door_price, :kind
      ])
  end

  def create_competition_params
    result = ActiveModelSerializers::Deserialization
      .jsonapi_parse(params, only: [
        :name, :initial_price,
        :at_the_door_price, :kind, :event
      ])
  end

end
