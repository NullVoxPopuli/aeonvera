module OrderMembership
  extend ActiveSupport::Concern

  def user_has_organization_discount?
    belongs_to_organization? &&
    self.user.is_member_of(self.host) &&
    self.host.membership_discounts.present?
  end

  def applicable_membership_discounts
    user_belongs_to_organization = (
      belongs_to_organization? &&
      self.user && self.user.is_member_of?(self.host)
    )

    if user_belongs_to_organization

      membership_discounts = self.host.membership_discounts

      if membership_discounts.present?
        return membership_discounts
      end
    end

    # there is notheng else to do, return something falsy
    false
  end

  def existing_membership_discounts
    self.line_items.select{ |i|
      i.line_item_type == MembershipDiscount.name
    }
  end

  def clear_existing_membership_discounts
    existing_membership_discounts.map(&:destroy)
  end

end
