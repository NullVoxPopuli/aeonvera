# frozen_string_literal: true
# object is actually an Event
# use separate serializer for summary, because there is a lot of data
# with each event
module Api
  class HostedEventSummarySerializer < ActiveModel::Serializer
    attributes :id, :name, :location,
               :registration_opens_at, :starts_at, :ends_at, :url,
               :total_registrations, :lead_registrations, :follow_registrations,
               :shirts_sold
  end
end
