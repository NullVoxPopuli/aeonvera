# frozen_string_literal: true

module Api
  module Users
    class RegistrationSerializer < ActiveModel::Serializer
      type 'users/registrations'

      attributes :id,
                 :attendee_name, :attendee_email, :dance_orientation,
                 :attendee_first_name, :attendee_last_name,
                 :amount_owed, :amount_paid, :registered_at,
                 :checked_in_at, :is_checked_in,
                 :level_name,
                 :interested_in_volunteering,
                 :city, :state, :zip, :phone_number,
                 :event_begins_at, :is_attending,
                 :url

      has_one :housing_request
      has_one :housing_provision
      has_many :custom_field_responses

      has_many :orders
      belongs_to :event, serializer: ::Api::EventSerializer
      belongs_to :level, serializer: ::Api::LevelSerializer
      belongs_to :unpaid_order
      def is_attending
        object.attending?
      end

      def amount_paid
        object.paid_amount
      end

      def registered_at
        object.created_at
      end

      def level_name
        object.try(:level).try(:name)
      end

      def event_begins_at
        object.event&.starts_at
      end

      def is_checked_in
        !!object.checked_in_at
      end

      def url
        object.host.url
      end
    end
  end
end
