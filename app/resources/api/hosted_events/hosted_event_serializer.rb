module Api
  # object is actually an Event
  class HostedEventSerializer < ActiveModel::Serializer
    type 'hosted_event'
    attributes :id, :name, :location,
      :registration_opens_at, :starts_at, :ends_at, :url,
      :number_of_leads, :number_of_follows, :number_of_shirts_sold,
      :my_event

    def number_of_leads
      object.registrations.leads.count
    end

    def number_of_follows
      object.registrations.follows.count
    end

    def number_of_shirts_sold
      object.shirts_sold
    end

    def my_event
      object.hosted_by_id == (scope || current_user).id
    end
  end
end
