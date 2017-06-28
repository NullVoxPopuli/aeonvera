module Api
  class EventSerializer < ActiveModel::Serializer
    include PublicAttributes::EventAttributes

    type 'events'

    has_many :attendances, serializer: AttendanceSerializer
  end
end
