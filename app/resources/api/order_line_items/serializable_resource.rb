# frozen_string_literal: true

module Api
  class OrderLineItemSerializableResource < ApplicationResource
    type 'order_line_items'

    attributes :price, :quantity,
               :order_id, :dance_orientation, :partner_name,
               :size, :color,
               :picked_up_at

    belongs_to :order, class: '::Api::OrderSerializableResource'
    belongs_to :line_item, class: { Package: '::Api::PackageSerializableResource',
                                    Competition: '::Api::CompetitionSerializableResource',
                                    'LineItem::Shirt': '::Api::ShirtSerializableResource',
                                    Discount: '::Api::DiscountSerializableResource',
                                    LineItem: '::Api::LineItemSerializableResource' }
  end
end
