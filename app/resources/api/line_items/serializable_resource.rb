# frozen_string_literal: true

module Api
  # object is actually an Registration in this serializer
  class LineItemSerializableResource < ApplicationResource
    include SharedAttributes::Stock
    include SharedAttributes::HasPicture

    type 'line-items'

    PUBLIC_ATTRIBUTES = [:id, :name, :current_price, :price,
                         :starts_at, :ends_at,
                         :registration_opens_at, :registration_closes_at,
                         :description, :expires_at,
                         :picture_url_thumb,
                         :picture_url_medium,
                         :picture_url].freeze

    PUBLIC_RELATIONSHIPS = [:host].freeze
    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

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
