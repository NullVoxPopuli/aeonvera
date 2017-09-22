# frozen_string_literal: true

module Api
  class OrderLineItemSerializableResource < ApplicationResource
    type 'order-line-items'

    attributes :price, :quantity,
               :order_id, :dance_orientation, :partner_name,
               :size, :color,
               :picked_up_at,
               :scratch

    belongs_to :order, class: '::Api::OrderSerializableResource' do
      linkage always: true
    end

    belongs_to :line_item, class: {
      Package: '::Api::PackageSerializableResource',
      Competition: '::Api::CompetitionSerializableResource',
      Discount: '::Api::DiscountSerializableResource',
      MembershipDiscount: '::Api::MembershipDiscountSerializableResource',
      LineItem: '::Api::LineItemSerializableResource',
      'LineItem::Shirt': '::Api::ShirtSerializableResource',
      'LineItem::Lesson': '::Api::LessonSerializableResource',
      'LineItem::MembershipOption': '::Api::MembershipOptionSerializableResource'
    }
  end
end
