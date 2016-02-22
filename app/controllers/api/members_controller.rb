class Api::MembersController < APIController

  def index
    search = User.ransack(params[:q])
    render json: search.result, serializer: MembershipSerializer::MemberSerializer
  end

end
