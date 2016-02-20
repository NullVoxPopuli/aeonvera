# this works with membership renewals, but at the organization level.
# membership renewals are bound to a membership option, hence the includes in index
class Api::MembershipsController < Api::ResourceController
  include OrganizationLoader
  before_action :set_organization

  def index
    # TODO: move this logic to an operation for testing
    options = current_organization.membership_options.includes(renewals: :user)
    renewals = options.map(&:renewals).flatten
    sorted_renewals = renewals.sort_by{|r| [r.user_id,r.updated_at]}.reverse

    # unique picks the first option.
    # so, because the list is sorted by user id, then updated at,
    # for each user, the first renewal will be chosen...
    # and because it is descending, that means the most recent renewal
    latest_renewals = sorted_renewals.uniq{|r| r.user_id}

    render json: latest_renewals, include: params[:include], each_serializer: MembershipSerializer
  end

  private


end
