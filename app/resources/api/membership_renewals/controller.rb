# frozen_string_literal: true
# this works with membership renewals, but at the organization level.
# membership renewals are bound to a membership option, hence the includes in index
module Api
  class MembershipRenewalsController < Api::ResourceController
    def index
      render json: model, include: params[:include], each_serializer: MembershipRenewalSerializer
    end

    private

    def create_membership_renewal_params
      whitelisted = whitelistable_params do |whitelister|
        whitelister.permit(:start_date, :membership_option_id, :member_id)
      end

      whitelisted.merge(user_id: whitelisted.delete(:member_id))
    end
  end
end
