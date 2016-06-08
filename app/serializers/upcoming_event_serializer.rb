# object is actually an Event
class UpcomingEventSerializer < ActiveModel::Serializer
  type 'upcoming-events'
  attributes :id, :name, :location,
    :registration_opens_at, :starts_at, :ends_at, :url,
    :logo_url_thumb, :logo_url_medium, :logo_url


  def logo_url_thumb
    object.logo.url(:thumb)
  end

  def logo_url_medium
    object.logo.url(:medium)
  end

  def logo_url
    object.logo.url(:original)
  end
end
