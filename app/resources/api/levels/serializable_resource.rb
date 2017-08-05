# frozen_string_literal: true

module Api
  class LevelSerializableResource < ApplicationResource
    include SharedAttributes::HasRegistrations

    type 'levels'


    PUBLIC_ATTRIBUTES = [:id, :event_id,
                         :name, :description,
                         :requirement].freeze

    PUBLIC_RELATIONSHIPS = [:event].freeze
    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    attributes :name, :description, :requirement, :deleted_at

    belongs_to :event, class: '::Api::EventSerializableResource'
    has_many :registrations, class: '::Api::Users::RegistrationSerializer'
  end
end
