module Api
  class MembershipDiscountSerializer < DiscountSerializer
    type 'membership_discount'

    belongs_to :organization

  end
end
