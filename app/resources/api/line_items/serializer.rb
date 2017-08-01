# frozen_string_literal: true

module Api
  # object is actually an Registration in this serializer
  class LineItemSerializer < ActiveModel::Serializer
    include PublicAttributes::LineItemAttributes
    include SharedAttributes::Stock

    PUBLIC_ATTRIBUTES = [:id, :name, :current_price, :price,
                         :starts_at, :ends_at,
                         :registration_opens_at, :registration_closes_at,
                         :description, :expires_at,
                         :picture_url_thumb,
                         :picture_url_medium,
                         :picture_url].freeze

    PUBLIC_RELATIONSHIPS = [:host].freeze
    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    has_many :registrations, each_serializer: ::Api::Users::RegistrationSerializer
    has_many :order_line_items
  end
end
