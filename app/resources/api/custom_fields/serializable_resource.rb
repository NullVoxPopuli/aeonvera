# frozen_string_literal: true

module Api
  class CustomFieldSerializableResource < ApplicationResource
    type 'custom-fields'

    attributes :label, :kind, :default_value, :editable

    belongs_to :host, class: { Event: '::Api::EventSerializableResource',
                               Organization: '::Api::OrganizationSerializableResource' }
    has_many :custom_field_responses, class: '::Api::CustomFieldResponseSerializableResource'
  end
end
