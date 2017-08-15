# frozen_string_literal: true

module Api
  class EventSummarySerializableResource < ApplicationResource
    include SharedAttributes::HasRegistrations

    type 'event-summaries'

    attributes :name, :location,
               :registration_opens_at, :starts_at, :ends_at, :url,
               :revenue, :unpaid

    attribute(:revenue) { (@object.revenue || 0).to_f }
    attribute(:unpaid) { (@object.unpaid_total || 0).to_f }
    attribute(:number_of_shirts_sold) { @object.shirts_sold }
    attribute(:my_event) { @object.hosted_by_id == @current_user&.id }

    has_many :registrations, class: '::Api::Events::RegistrationSerializableResource' do
      data do
        @object.recent_registrations
      end
    end
  end
end
