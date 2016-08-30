# frozen_string_literal: true
class ShirtSerializer < ActiveModel::Serializer
  include PublicAttributes::LineItemAttributes
  include SharedAttributes::Stock

  type 'shirt'
  attributes :sizes

  has_many :order_line_items

  def sizes
    available = (object.metadata['sizes'] || []).reject(&:blank?)
    result = []

    available.each_with_index do |s, _i|
      purchased = object.order_line_items.where(size: s).count
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
