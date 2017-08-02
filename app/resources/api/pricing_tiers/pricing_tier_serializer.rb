# frozen_string_literal: true

module Api
  class PricingTierSerializer < ActiveModel::Serializer
    include PublicAttributes::PricingTierAttributes

    PUBLIC_ATTRIBUTES = [:id, :increase_by_dollars, :date, :registrants, :is_opening_tier].freeze
    PUBLIC_RELATIONSHIPS = [:event].freeze
    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    attributes(*PUBLIC_ATTRIBUTES, :number_of_leads, :number_of_follows)

    has_many :registrations, each_serializer: ::Api::Users::RegistrationSerializer
    belongs_to :event

    def number_of_follows
      object.registrations.follows.count
    end

    def number_of_leads
      object.registrations.leads.count
    end
  end
end
