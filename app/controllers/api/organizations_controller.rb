class Api::OrganizationsController < APIController
  include SkinnyControllers::Diet

  def index
    render json: model
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

  def update_organization_params

  end

  def create_organization_params

  end

end
