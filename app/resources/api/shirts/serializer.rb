# frozen_string_literal: true
module Api
  class ShirtSerializer < ActiveModel::Serializer
    include PublicAttributes::LineItemAttributes
    include SharedAttributes::Stock

    PUBLIC_ATTRIBUTES = Array[*LineItemSerializer::PUBLIC_ATTRIBUTES, :sizes]
    PUBLIC_RELATIONSHIPS = LineItemSerializer::PUBLIC_RELATIONSHIPS
    PUBLIC_FIELDS = Array[*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS]

    type 'shirts'
    attributes :sizes

    has_many :order_line_items

    def sizes
      available = (object.metadata['sizes'] || []).reject(&:blank?)
      result = []

      available.each_with_index do |s, _i|
        purchased = object.order_line_items.where(size: s).sum(:quantity)
        inventory = object.inventory_for_size(s).to_i

        result << {
          id: s,
          size: s,
          price:  object.price_for_size(s),
          inventory: inventory,
          purchased: purchased,
          remaining: inventory - purchased
        }
      end

      result
    end
  end
end
