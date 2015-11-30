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
end
