class OrderLineItemSerializer < ActiveModel::Serializer
  type 'order-line-item'
  attributes :id, :price, :quantity,
    :order_id, :dance_orientation, :partner_name,
    :size, :color,
    :picked_up_at

  belongs_to :line_item
  belongs_to :order
end
