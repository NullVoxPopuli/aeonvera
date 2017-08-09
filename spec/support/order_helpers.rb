# frozen_string_literal: true

def add_to_order(order, line_item, quantity: 1, price: 0)
  price = line_item.try(:current_price) ||
    line_item.try(:price) ||
    line_item.try(:value) || price
  oli = OrderLineItem.new(
    line_item: line_item,
    line_item_type: line_item.class.name,
    order: order,
    price: price,
    quantity: quantity
  )

  order.order_line_items << oli
  oli
end

def add_to_order!(order, line_item, quantity: 1, price: 0)
  oli = add_to_order(order, line_item, quantity: quantity, price: price)
  oli.save
  order.save!

  oli
end

# simulates not saving
def remove_invalid_items(order)
  items = order.order_line_items
  items = items.select { |o| !o.valid? }

  order.order_line_items.delete(items)
end
