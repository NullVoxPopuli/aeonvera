# frozen_string_literal: true

module Api
  # object is actually an Registration in this serializer
  class IntegrationSerializableResource < ApplicationResource
    type 'integrations'

    PUBLIC_ATTRIBUTES = [:id, :kind, :publishable_key].freeze
    PUBLIC_RELATIONSHIPS = [:owner].freeze

    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    attributes(:kind)

    attribute(:publishable_key) do
      @object.config.try(:[], 'stripe_publishable_key') if @object.kind == Integration::STRIPE
    end

    belongs_to :owner, class: {
      Event: '::Api::EventSerializableResource',
      Organization: '::Api::OrganizationSerializableResource'
    } do
      linkage always: true
    end
  end
end
