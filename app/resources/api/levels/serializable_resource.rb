# frozen_string_literal: true

module Api
  class LevelSerializableResource < ApplicationResource
    type 'levels'

    attributes :name, :description, :requirement, :deleted_at

    attribute(:number_of_follows) { @object.registrations.follows.size }
    attribute(:number_of_leads) { @object.registrations.leads.size }

    belongs_to :event, class: '::Api::EventSerializableResource'
    has_many :registrations, class: '::Api::Users::RegistrationSerializer'
  end
end
