# frozen_string_literal: true

module Api
  class CustomFieldResponseSerializableResource < ApplicationResource
    type 'custom-field-responses'

    attributes :value

    belongs_to :writer, class: { Registration: '::Api::Users::RegistrationSerializableResource' }
    belongs_to :custom_field, class: '::Api::CustomFieldSerializableResource'
  end
end
