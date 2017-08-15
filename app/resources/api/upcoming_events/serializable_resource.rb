# frozen_string_literal: true

module Api
  # object is actually an Event
  class UpcomingEventSerializableResource < ApplicationResource
    include SharedAttributes::HasLogo

    type 'upcoming-events'

    attributes :name, :location,
               :registration_opens_at, :starts_at, :ends_at, :url,
               :domain
  end
end
