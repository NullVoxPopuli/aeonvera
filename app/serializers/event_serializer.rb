class EventSerializer < ActiveModel::Serializer
  include PublicAttributes::EventAttributes


  has_many :attendances, serializer: AttendanceSerializer
end
