# object is actually an Event
class HostedEventSerializer < ActiveModel::Serializer
  attributes :id, :name, :location,
    :registration_opens_at, :starts_at, :ends_at, :url
end
