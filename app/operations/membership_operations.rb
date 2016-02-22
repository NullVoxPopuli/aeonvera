module MembershipOperations
  class ReadAll < SkinnyControllers::Operation::Base

    def run
      # default 'model' functionality is avoided
      latest_renewals
    end

    private

    def organization
      id = params[:organization_id]
      Organization.find(id)
      # TODO use a the OrganizationOperation to verify the Organization
    end

    def renewals
      organization.membership_options.includes(renewals: [:user, :membership_option]).map(&:renewals).flatten
    end

    def latest_renewals
      sorted_renewals = renewals.sort_by{|r| [r.user_id,r.updated_at]}.reverse

      # unique picks the first option.
      # so, because the list is sorted by user id, then updated at,
      # for each user, the first renewal will be chosen...
      # and because it is descending, that means the most recent renewal
      sorted_renewals.uniq{|r| r.user_id}
    end
  end

end
