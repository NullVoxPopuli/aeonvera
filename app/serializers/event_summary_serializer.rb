# object is actually an Event
class EventSummarySerializer < HostedEventSerializer

  attributes :id, :name, :location,
    :registration_opens_at, :starts_at, :ends_at, :url,
    :number_of_leads, :number_of_follows, :number_of_shirts_sold,
    :revenue, :unpaid

    has_many :recent_attendees

    def revenue
      object.revenue || 0
    end

    def unpaid
      object.unpaid_total || 0
    end

    def recent_attendees
      object.attendances.limit(5).order("created_at DESC")
    end
end
