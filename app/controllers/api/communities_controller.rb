class Api::CommunitiesController < APIController
  # for create/edit/delete
  # include SkinnyControllers::Diet

  def index
    render json: Organization.all, include: params[:include]
  end

  def show
    render json: Organization.find(params[:id]), include: params[:include]

end
