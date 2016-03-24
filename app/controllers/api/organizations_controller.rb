class Api::OrganizationsController < APIController
  include SkinnyControllers::Diet
  before_filter :must_be_logged_in, except: [:index]

  def index
    # TODO: add a `self.parent = :method` to SkinnyControllers
    if params[:mine]
      organizations = current_user.organizations
      render json: organizations, inclrude: params[:include]
    else
      render json: model, include: params[:include]
    end

  end

  def show
    render json: model, include: params[:include]
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
