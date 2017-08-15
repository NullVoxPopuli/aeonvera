# frozen_string_literal: true

module Api
  class PackageSerializableResource < ApplicationResource
    type 'packages'

    PUBLIC_ATTRIBUTES = [:id, :name,
                         :initial_price, :at_the_door_price,
                         :attendee_limit,
                         :expires_at,
                         :requires_track,
                         :description,
                         :current_price].freeze

    PUBLIC_RELATIONSHIPS = [:event].freeze
    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    attributes(:name,
               :initial_price, :at_the_door_price,
               :attendee_limit,
               :expires_at,
               :requires_track,
               :description,
               :current_price)

    belongs_to :event, class: '::Api::EventSerializableResource'
    has_many :registrations, class: '::Api::Users::RegistrationSerializableResource'
  end
end
