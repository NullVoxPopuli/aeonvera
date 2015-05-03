module HasMemberships
  extend ActiveSupport::Concern

  included do
    has_many :renewals, class_name: "::MembershipRenewal"
    has_many :memberships, through: :renewals, source: :user
  end

  def is_renewal_active?(renewal)
    if renewal.is_a?(LineItem::MembershipOption)
      renewal = latest_renewal_for_membership(renewal)
    end

    renewal.present? && !renewal.expired?
  end

  def is_member_of?(organization)
    organization.membership_options.each do |option|
      if self.is_renewal_active?(option)
        return true
      end
    end

    return false
  end

  def membership_expires_at(organization)
    renewal = latest_active_renewal(organization)
    renewal.try(:expires_at)
  end

  def latest_active_renewal(organization)
    latest = nil
    organization.membership_options.each do |option|
      local_latest = latest_renewal_for_membership(option)
      if is_renewal_active?(local_latest)
        if latest and latest.duration < local_tatest.duration
          latest = local_latest
        end
        latest = local_latest if latest.nil?
      end
    end

    latest
  end

  def first_renewal_for_membership(membership_option)
    membership_option.renewals.where(user_id: self.id).first
  end

  def latest_renewal_for_membership(membership_option)
    membership_option.renewals.where(user_id: self.id).last
  end
end
