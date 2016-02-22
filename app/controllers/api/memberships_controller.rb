# this works with membership renewals, but at the organization level.
# membership renewals are bound to a membership option, hence the includes in index
class Api::MembershipsController < Api::ResourceController
  include OrganizationLoader
  before_action :set_organization

  def index
    render json: model, include: params[:include], each_serializer: MembershipSerializer
  end

  private


end
