class Api::OrganizationsController < APIController
  include SkinnyControllers::Diet

  def index
    # TODO: add a `self.parent = :method` to SkinnyControllers
    render json: current_user.organizations, include: params[:include]
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


  def set_mine
    if params[:mine]
      params[:owner_id] = current_user.id
    end
  end

  def update_organization_params

  end

  def create_organization_params

  end

end
