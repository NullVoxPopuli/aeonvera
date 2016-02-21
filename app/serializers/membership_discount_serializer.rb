class MembershipDiscountSerializer < DiscountSerializer
  type 'membership_discounts'
  
  belongs_to :organization

end
