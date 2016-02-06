class OrderLineItemSerializer < ActiveModel::Serializer
  class LineItemSerializer < ActiveModel::Serializer
    type 'line-item'
    attributes :id, :name
  end

  attributes :id,
    :price, :quantity,
    :order_id

  belongs_to :line_item, serializer: OrderLineItemSerializer::LineItemSerializer

end
