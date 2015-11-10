class OrderLineItemSerializer < ActiveModel::Serializer

  attributes :id,
    :price, :quantity,
    :order_id

  belongs_to :line_item

end
