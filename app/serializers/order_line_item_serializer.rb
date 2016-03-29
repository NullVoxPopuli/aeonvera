class OrderLineItemSerializer < ActiveModel::Serializer
  type 'order-line-item'
  attributes :id, :price, :quantity, :order_id, :dance_orientation, :partner_name, :size, :color

  class LineItemSerializer < ActiveModel::Serializer
    type 'line-item'
    attributes :id, :name
  end


  belongs_to :line_item, serializer: OrderLineItemSerializer::LineItemSerializer
  belongs_to :order
end
