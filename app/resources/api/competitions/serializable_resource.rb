# frozen_string_literal: true

module Api
  class CompetitionSerializableResource < ApplicationResource
    type 'competitions'

    include SharedAttributes::HasOrderLineItems

    PUBLIC_ATTRIBUTES = [:id, :name,
                         :initial_price, :at_the_door_price, :current_price,
                         :kind, :kind_name,
                         :requires_orientation, :requires_partner,
                         :description, :nonregisterable].freeze

    PUBLIC_RELATIONSHIPS = [:event].freeze
    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    attributes :name,
               :initial_price, :at_the_door_price, :current_price,
               :kind, :kind_name,
               :requires_orientation, :requires_partner,
               :description, :nonregisterable

    has_many :order_line_items, class: '::Api::OrderLineItemSerializableResource'
    belongs_to :event, class: '::Api::EventSerializableResource' do
      linkage always: true
    end
  end
end
