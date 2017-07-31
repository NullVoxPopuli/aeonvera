# object is actually an Event
module Api
  class EventSummarySerializer < Api::HostedEventSerializer
    type 'event_summary'
    attributes :id, :name, :location,
      :registration_opens_at, :starts_at, :ends_at, :url,
      :number_of_leads, :number_of_follows, :number_of_shirts_sold,
      :revenue, :unpaid, :event_id

    has_many :registrations, each_serializer: ::Api::Users::RegistrationSerializer

    def registrations
      object.recent_registrations
    end

    def event_id
      object.id
    end

    def revenue
      (object.revenue || 0).to_f
    end

    def unpaid
      (object.unpaid_total || 0).to_f
    end
  end
end
