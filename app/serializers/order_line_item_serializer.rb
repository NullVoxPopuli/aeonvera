class OrderLineItemSerializer < ActiveModel::Serializer
  type 'order_line_items'
  attributes :id, :price, :quantity,
    :order_id, :dance_orientation, :partner_name,
    :size, :color,
    :picked_up_at

  belongs_to :line_item
  belongs_to :order
end
