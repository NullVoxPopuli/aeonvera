# object is actually an Event
class EventSummarySerializer < HostedEventSerializer
  type 'event_summary'
  attributes :id, :name, :location,
    :registration_opens_at, :starts_at, :ends_at, :url,
    :number_of_leads, :number_of_follows, :number_of_shirts_sold,
    :revenue, :unpaid

  has_many :event_attendances
  def event_attendances
    object.recent_registrations
  end

  def revenue
    (object.revenue || 0).to_f
  end

  def unpaid
    (object.unpaid_total || 0).to_f
  end
end
