class Api::ResourceController < APIController
  include SkinnyControllers::Diet

  def index
    render json: model, include: params[:include]
  end

  def show
    render json: model
  end

  def create
    if model.errors.present?
      render json: model.errors.to_json_api, status: 422
    else
      render json: model
    end
  end

  def update
    if model.errors.present?
      render json: model.errors.to_json_api, status: 422
    else
      render json: model
    end
  end

  def destroy
    render json: model
  end

end
