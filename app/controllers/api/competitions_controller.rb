class Api::CompetitionsController < APIController
  include SkinnyControllers::Diet

  def index
    render json: model, include: 'order_line_items.attendance'
  end

  def show
    respond_to do |format|
      format.json { render json: model, include: params[:include] }
    end
  end

end
