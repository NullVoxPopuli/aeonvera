class Api::LevelsController < APIController
  include SkinnyControllers::Diet

  def index
    render json: model, include: params[:include]
  end

  def show
    render json: model
  end

  def create
    render json: model
  end

  def update
    render json: model
  end

  private

  def update_level_params
    params
      .require(:data)
      .require(:attributes)
      .permit(:name, :requirement)
  end

  def create_level_params
    params
      .require(:data)
      .require(:attributes)
      .permit(:name, :requirement, :event_id)
  end


end
