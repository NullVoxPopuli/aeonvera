module Api
  class EventSerializer < ActiveModel::Serializer
    include PublicAttributes::EventAttributes

    type 'events'

    has_many :registrations, serializer: RegistrationSerializer
  end
end
