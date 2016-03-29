class Api::CompetitionsController < APIController
  include SkinnyControllers::Diet

  def index
    render json: model, include: 'order_line_items.attendance'
  end

  def show
    render json: model
  end

end
