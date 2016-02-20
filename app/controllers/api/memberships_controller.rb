# this works with membership renewals, but at the organization level.
# membership renewals are bound to a membership option, hence the includes in index
class Api::MembershipsController < Api::ResourceController
  include OrganizationLoader
  before_action :set_organization

  def index
    options = current_organization.membership_options.includes(renewals: :user)
    renewals = options.map(&:renewals).flatten
    render json: renewals, include: params[:include], each_serializer: MembershipSerializer
  end

  private


end
