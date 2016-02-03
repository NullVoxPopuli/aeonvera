class Api::CommunitiesController < APIController
  # for create/edit/delete 
  # include SkinnyControllers::Diet

  def index
    render json: Organization.all, each_serializer: CommunitySerializer
  end

  def show
    render json: Organization.find(params[:id]), serializer: CommunitySerializer
  end

end
