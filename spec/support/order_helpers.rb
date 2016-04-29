def add_to_order(order, line_item, quantity: 1, price: 0)
  price = line_item.try(:current_price) ||
          line_item.try(:price) ||
          line_item.try(:value)
  oli = OrderLineItem.new(
    line_item: line_item,
    order: order,
    price: price,
    quantity: quantity)

  order.order_line_items << oli if oli.valid?
  oli
end
