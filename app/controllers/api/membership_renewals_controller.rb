# this works with membership renewals, but at the organization level.
# membership renewals are bound to a membership option, hence the includes in index
class Api::MembershipRenewalsController < Api::ResourceController

  def index
    render json: model, include: params[:include], each_serializer: MembershipRenewalSerializer
  end

  private

  def create_membership_renewal_params
    data = params.require(:data)
    attributes = data
      .require(:attributes)
      .permit(:start_date)

    relationships = data.require(:relationships)

    user_id = relationships
      .require(:member)
      .require(:data)
      .permit(:id)

    membership_option_id = relationships
      .require(:membership_option)
      .require(:data)
      .permit(:id)

    attributes.merge(
      user_id: user_id,
      membership_option_id: membership_option_id)
  end

end
