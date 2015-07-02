# object is actually an Event
class UpcomingEventSerializer < ActiveModel::Serializer
  attributes :id, :name, :location,
    :registration_opens_at, :starts_at, :ends_at, :url
end
