# frozen_string_literal: true

module Api
  class CustomFieldSerializableResource < ApplicationResource
    PUBLIC_ATTRIBUTES = [:id, :label, :kind, :default_value, :editable].freeze
    PUBLIC_RELATIONSHIPS = [:host].freeze
    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    type 'custom-fields'

    attributes :label, :kind, :default_value, :editable

    belongs_to :host, class: { Event: '::Api::EventSerializableResource',
                               Organization: '::Api::OrganizationSerializableResource' }
    has_many :custom_field_responses, class: '::Api::CustomFieldResponseSerializableResource'
  end
end
