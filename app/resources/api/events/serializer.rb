# frozen_string_literal: true
module Api
  class EventSerializer < ActiveModel::Serializer
    include PublicAttributes::EventAttributes

    type 'events'

    has_many :registrations, serializer: Users::RegistrationSerializer
  end
end
