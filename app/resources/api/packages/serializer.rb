# frozen_string_literal: true
module Api
  class PackageSerializer < ActiveModel::Serializer
    include PublicAttributes::PackageAttributes

    PUBLIC_ATTRIBUTES = [:id, :name,
                         :initial_price, :at_the_door_price,
                         :attendee_limit,
                         :expires_at,
                         :requires_track,
                         :description,
                         :current_price].freeze

    PUBLIC_RELATIONSHIPS = [:event].freeze
    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    attributes :number_of_leads, :number_of_follows

    belongs_to :event
    has_many :registrations, each_serializer: ::Api::Users::RegistrationSerializer

    def number_of_leads
      object.registrations.leads.count
    end

    def number_of_follows
      object.registrations.follows.count
    end
  end
end
