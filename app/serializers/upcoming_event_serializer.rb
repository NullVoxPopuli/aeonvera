# object is actually an Event
class UpcomingEventSerializer < ActiveModel::Serializer
  type 'upcoming-events'
  attributes :id, :name, :location,
    :registration_opens_at, :starts_at, :ends_at, :url
end
