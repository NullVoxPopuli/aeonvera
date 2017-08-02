# frozen_string_literal: true

module Api
  module Users
    class RegistrationSerializer < ActiveModel::Serializer # ApplicationResource
      type 'users/registrations'

      ATTRIBUTES = [
        :id,
        :attendee_name, :attendee_email, :dance_orientation,
        :attendee_first_name, :attendee_last_name,
        :amount_owed, :amount_paid, :registered_at,
        :checked_in_at, :is_checked_in,
        :level_name,
        :interested_in_volunteering,
        :city, :state, :zip, :phone_number,
        :event_begins_at, :is_attending,
        :url
      ].freeze

      RELATIONSHIPS = [
        :event, :orders, :unpaid_order,
        :level,
        :custom_field_responses,
        :housing_request, :housing_provision
      ].freeze

      FIELDS = Array[*ATTRIBUTES, *RELATIONSHIPS]

      attributes(*ATTRIBUTES)

      has_one :housing_request, serializer: ::Api::HousingRequestSerializer
      has_one :housing_provision, serializer: ::Api::HousingProvisionSerializer
      has_many :custom_field_responses, each_serializer: ::Api::CustomFieldSerializer

      belongs_to :event, serializer: ::Api::EventSerializer
      belongs_to :level, serializer: ::Api::LevelSerializer

      belongs_to :unpaid_order, serializer: ::Api::OrderSerializer
      has_many :orders, each_serializer: ::Api::OrderSerializer

      def event_begins_at
        object.event&.starts_at
      end

      def url
        object.host.url
      end

      def registered_at
        object.created_at
      end

      def level_name
        object.try(:level).try(:name)
      end

      def amount_paid
        object.paid_amount
      end

      def is_attending
        object.attending?
      end

      def is_checked_in
        !!object.checked_in_at
      end
    end
  end
end
