class MembershipOption < LineItem::MembershipOption
  class << self
    def sti_name
      LineItem::MembershipOption.name
    end
  end
end
