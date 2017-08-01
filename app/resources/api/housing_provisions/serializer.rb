# frozen_string_literal: true

module Api
  class HousingProvisionSerializer < ActiveModel::Serializer
    PUBLIC_ATTRIBUTES = [
      :id, :name,
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

    attributes(PUBLIC_ATTRIBUTES)

    belongs_to :host
    belongs_to :registration, serializer: Users::RegistrationSerializer
  end
end
