class Api::IntegrationsController < APIController
  include SkinnyControllers::Diet

  def show
    render json: model
  end

  # TODO: write a polic for this.
  #       only the owner can delete integrations
  def destroy
    render json: model
  end
end
