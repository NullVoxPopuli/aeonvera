class Api::ResourceController < APIController
  include SkinnyControllers::Diet

  def index
    format.json { render json: model, include: params[:include] }
  end

  def show
    render json: model, include: params[:include]
  end

  def create
    render_model
  end

  def update
    render_model
  end

  def destroy
    render json: model
  end
end
