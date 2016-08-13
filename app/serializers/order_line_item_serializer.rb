class OrderLineItemSerializer < ActiveModel::Serializer
  type 'order-line-item'
  attributes :id, :price, :quantity, :order_id, :dance_orientation, :partner_name, :size, :color

  belongs_to :line_item
  belongs_to :order
end
