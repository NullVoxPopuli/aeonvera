# frozen_string_literal: true

module Api
  class LessonSerializableResource < ApplicationResource
    type 'lessons'

    attributes :name, :current_price, :price,
               # :number_purchased,
               :starts_at, :ends_at, :schedule,
               :duration_amount, :duration_unit,
               :registration_opens_at, :registration_closes_at,
               :description,
               :expires_at

    has_many :registrations, class: '::Api::Users::RegistrationSerializableResource'
    has_many :order_line_items, class: '::Api::OrderLineItemSerializableResource'
  end
end
