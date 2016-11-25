# frozen_string_literal: true
module HasMemberships
  extend ActiveSupport::Concern

  included do
    has_many :renewals, class_name: '::MembershipRenewal'
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
      return true if is_renewal_active?(option)
    end

    false
  end

  def membership_expires_at(organization)
    renewal = latest_active_renewal(organization)
    renewal.try(:expires_at)
  end

  def latest_active_renewal(organization)
    latest = nil

    organization.membership_options.each do |option|
      local_latest = latest_renewal_for_membership(option)
      next unless is_renewal_active?(local_latest)

      latest = local_latest if latest && latest.duration < local_tatest.duration
      latest = local_latest if latest.nil?
    end

    latest
  end

  def first_renewal_for_membership(membership_option)
    membership_option.renewals.where(user_id: id).first
  end

  def latest_renewal_for_membership(membership_option)
    membership_option.renewals.where(user_id: id).last
  end
end
