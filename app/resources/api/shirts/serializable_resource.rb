# frozen_string_literal: true

module Api
  class ShirtSerializableResource < ApplicationResource
    type 'shirts'

    # include SharedAttributes::Stock

    PUBLIC_ATTRIBUTES = Array[*LineItemSerializer::PUBLIC_ATTRIBUTES, :sizes]
    PUBLIC_RELATIONSHIPS = LineItemSerializer::PUBLIC_RELATIONSHIPS
    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    attributes :name, :current_price, :price,
               :starts_at, :ends_at, :schedule,
               :duration_amount, :duration_unit,
               :registration_opens_at, :registration_closes_at,
               :description,
               :expires_at,
               :initial_stock

    attribute(:sizes) do
      available = (@object.metadata['sizes'] || []).reject(&:blank?)
      result = []

      available.each_with_index do |s, _i|
        purchased = @object.order_line_items.where(size: s).sum(:quantity)
        inventory = @object.inventory_for_size(s).to_i

        result << {
          id: s,
          size: s,
          price:  @object.price_for_size(s),
          inventory: inventory,
          purchased: purchased,
          remaining: inventory - purchased
        }
      end

      result
    end

    attribute(:number_purchased) { @object.order_line_items.count }
    attribute(:picture_url_thumb) { @object.picture.url(:thumb) }
    attribute(:picture_url_medium) { @object.picture.url(:medium) }
    attribute(:picture_url) { @object.picture.url(:original) }
    attribute(:remaining_stock) { @object.initial_stock - @object.order_line_items.count }
    attribute(:number_purchased) { @object.order_line_items.count }

    belongs_to :host, class: { Event: '::Api::EventSerializableResource',
                               Organization: '::Api::OrganizationSerializableResource' }
    has_many :order_line_items, class: '::Api::OrderLineItemSerializableResource'
  end
end
