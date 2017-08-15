# frozen_string_literal: true

module Api
  class SponsorshipSerializableResource < ApplicationResource
    PUBLIC_ATTRIBUTES = [:id].freeze
    PUBLIC_RELATIONSHIPS = [:sponsor, :sponsored, :discount].freeze
    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    belongs_to :sponsor, class: {
      Organization: '::Api::OrganizationSerializableResource'
    }

    belongs_to :sponsored, class: {
      Event: '::Api::EventSerializableResource'
    }

    belongs_to :discount, class: '::Api::DiscountSerializableResource'
  end
end
