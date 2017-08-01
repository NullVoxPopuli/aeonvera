# frozen_string_literal: true

module Api
  class CustomFieldSerializer < ActiveModel::Serializer
    PUBLIC_ATTRIBUTES = [:id, :label, :kind, :default_value, :editable].freeze
    PUBLIC_RELATIONSHIPS = [:host].freeze
    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    attributes(PUBLIC_ATTRIBUTES)

    belongs_to :host
    has_many :custom_field_responses
  end
end
