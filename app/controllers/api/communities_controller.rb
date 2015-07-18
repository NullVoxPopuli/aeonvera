class Api::CommunitiesController < APIController

  def index
    render json: Organization.all, each_serializer: CommunitySerializer
  end

end
