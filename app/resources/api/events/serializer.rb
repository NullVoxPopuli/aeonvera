# frozen_string_literal: true

module Api
  class EventSerializer < ActiveModel::Serializer
    include PublicAttributes::EventAttributes

    has_many :registrations, class: Users::RegistrationSerializer
  end
end
