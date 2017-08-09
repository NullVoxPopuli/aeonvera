# frozen_string_literal: true

module Api
  # object is actually an Event
  class HostedEventSerializableResource < ApplicationResource
    include SharedAttributes::HasRegistrations

    type 'hosted-events'

    attributes :name, :location,
               :registration_opens_at, :starts_at, :ends_at, :url

    # query for order ids and order_line_item quantities (2 total)
    # - no AR Allocations
    attribute(:number_of_shirts_sold) { @object.shirts_sold }

    attribute(:my_event) do
      @object.hosted_by_id == @current_user.id
    end
  end
end
