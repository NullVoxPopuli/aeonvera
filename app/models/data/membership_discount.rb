class MembershipDiscount < Discount
  belongs_to :organization, class_name: Organization.name,
    foreign_key: "host_id", foreign_type: "host_type", polymorphic: true
end
