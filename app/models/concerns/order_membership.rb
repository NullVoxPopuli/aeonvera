# frozen_string_literal: true
module OrderMembership
  extend ActiveSupport::Concern

  def user_has_organization_discount?
    belongs_to_organization? &&
      user.is_member_of(host) &&
      host.membership_discounts.present?
  end

  def applicable_membership_discounts
    user_belongs_to_organization = (
      belongs_to_organization? &&
      user && user.is_member_of?(host)
    )

    if user_belongs_to_organization

      membership_discounts = host.membership_discounts

      return membership_discounts if membership_discounts.present?
    end

    # there is notheng else to do, return something falsy
    false
  end

  def existing_membership_discounts
    order_line_items.select do |i|
      i.line_item_type == MembershipDiscount.name
    end
  end

  def clear_existing_membership_discounts
    existing_membership_discounts.map(&:destroy)
  end
end
