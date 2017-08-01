# frozen_string_literal: true

module Api
  # object is actually an Registration in this serializer
  class IntegrationSerializer < ActiveModel::Serializer
    PUBLIC_ATTRIBUTES = [:id, :kind, :publishable_key].freeze
    PUBLIC_RELATIONSHIPS = [:owner].freeze

    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    attributes(*PUBLIC_ATTRIBUTES, :owner_id, :owner_type)

    belongs_to :owner

    def publishable_key
      return unless object.kind == Integration::STRIPE

      object.config.try(:[], 'stripe_publishable_key')
    end
  end
end
