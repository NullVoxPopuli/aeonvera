class Api::IntegrationsController < APIController
  include SkinnyControllers::Diet

  def show
    render json: model
  end
end
