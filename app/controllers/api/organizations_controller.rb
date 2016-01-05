class Api::OrganizationsController < APIController
  include SkinnyControllers::Diet

  def index
    set_mine
    # model = operation_class.new(current_user, params, index_params).run
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
