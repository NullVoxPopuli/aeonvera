# frozen_string_literal: true

module Api
  class PricingTierSerializableResource < ApplicationResource
    include SharedAttributes::HasRegistrations

    type do
      @object.event.opening_tier == @object ? 'opening-tiers' : 'pricing-tiers'
    end

    PUBLIC_ATTRIBUTES = [:id, :increase_by_dollars, :date, :registrants, :is_opening_tier].freeze
    PUBLIC_RELATIONSHIPS = [:event].freeze
    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    attributes(:increase_by_dollars, :date, :registrants, :is_opening_tier)

    has_many :registrations, class: '::Api::Users::RegistrationSerializableResource'
    belongs_to :event, class: '::Api::EventSerializableResource'

    attribute(:is_opening_tier) do
      @object == @object.event.opening_tier
    end
  end
end
