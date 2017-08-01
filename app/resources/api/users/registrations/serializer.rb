# frozen_string_literal: true

module Api
  module Users
    class RegistrationSerializer < ApplicationResource
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

      attributes(:id,
                 :attendee_name, :attendee_email, :dance_orientation,
                 :attendee_first_name, :attendee_last_name,
                 :amount_owed,
                 :checked_in_at,
                 :interested_in_volunteering,
                 :city, :state, :zip, :phone_number)

      attribute(:event_begins_at) { @object.event&.starts_at }
      attribute(:url) { @object.host.url }
      attribute(:registered_at) { @object.created_at }
      attribute(:level_name) { @object.try(:level).try(:name) }
      attribute(:amount_paid) { @object.paid_amount }
      attribute(:is_attending) { @object.attending? }
      attribute(:is_checked_in) { !!@object.checked_in_at }

      has_one :housing_request, class: ::Api::HousingRequestSerializer
      has_one :housing_provision, class: ::Api::HousingProvisionSerializer
      has_many :custom_field_responses, class: ::Api::CustomFieldSerializer

      belongs_to :event, class: ::Api::EventSerializer
      belongs_to :level, class: ::Api::LevelSerializer

      belongs_to :unpaid_order, class: ::Api::OrderSerializer
      has_many :orders, class: ::Api::OrderSerializer
    end
  end
end
