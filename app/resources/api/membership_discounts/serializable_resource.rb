# frozen_string_literal: true

module Api
  class MembershipDiscountSerializableResource < DiscountSerializableResource
    type 'membership-discounts'

    belongs_to :organization, class: '::Api::OrganizationSerializableResource'
  end
end
