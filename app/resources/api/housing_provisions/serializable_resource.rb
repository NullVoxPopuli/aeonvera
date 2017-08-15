# frozen_string_literal: true

module Api
  class HousingProvisionSerializableResource < ApplicationResource
    type 'housing-provisions'

    PUBLIC_ATTRIBUTES = [
      :id,
      :housing_capacity,
      :number_of_showers,
      :can_provide_transportation,
      :transportation_capacity,
      :preferred_gender_to_host,
      :has_pets,
      :smokes,
      :notes
    ].freeze

    PUBLIC_RELATIONSHIPS = [:host].freeze

    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    attributes(:housing_capacity,
               :number_of_showers,
               :can_provide_transportation,
               :transportation_capacity,
               :preferred_gender_to_host,
               :has_pets,
               :smokes,
               :notes)

    belongs_to :host, class: { Event: '::Api::EventSerializableResource',
                               Organization: '::Api::OrganizationSerializableResource' } do
      linkage always: true
    end

    belongs_to :registration, class: '::Api::Users::RegistrationSerializableResource' do
      linkage always: true
    end
  end
end
