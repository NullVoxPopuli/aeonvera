module OrderMembership
  extend ActiveSupport::Concern


  def apply_membership_discount
    membership_discounts = applicable_membership_discounts

    if membership_discounts.present?
      clear_existing_membership_discounts

      # for each line item that matches each discount's affects
      # add a discount object to the order
      membership_discounts.each do |discount|
        affects_klass = discount.affects

        affected_line_items = self.line_items.select{ |i|
          i.line_item_type == affects_klass
        }

        affected_line_items.each do |item|
          price = item.price
          discount_amount = discount.discounted_amount_of(item)

          discount_line_item = self.line_items.new(
            quantity: item.quantity,
            price: discount_amount,
            line_item_id: discount.id,
            line_item_type: discount.class.name
          )
          discount_line_item.save
          discount
        end
      end
    end
  end

  def process_membership
    if belongs_to_organization?
      if self.paid_was == false && self.paid?
        # became paid

        # do we contain a membership option?
        membership_options = line_items.select{|i|
          i.line_item_type == LineItem::MembershipOption.name
        }

        if membership_options.present?
          # iterate through each option, creating a renewal
          # for the user
          membership_options.each do |option|
            option.line_item.create_renewal_for_user(self.user)
          end
        end
      end
    end
  end

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
