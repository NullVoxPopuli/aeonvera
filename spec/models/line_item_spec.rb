require 'rails_helper'

describe LineItem::RaffleTicket do

  describe 'associations' do
    # when relationships get complicated... we unit test them.
    # that's how it works in real life, right?
    context 'order_line_items' do
      it 'has order_line_items' do
        item = LineItem.new
        oli = item.order_line_items.new

        items = item.order_line_items
        expect(items.first).to eq oli
      end

      it 'relates when persisted' do
        item = LineItem.new
        item.save(validate: false)

        oli = OrderLineItem.new(line_item: item)
        oli.save(validate: false)

        item.reload
        items = item.order_line_items
        expect(items.first).to eq oli
      end
    end


    context 'orders' do
      it 'has orders' do
        skip('is there a way to make this work?')
        item = LineItem.new
        order = Order.new
        OrderLineItem.new(order: order, line_item: item)

        related_order = item.orders.first
        expect(related_order).to eq order
      end

      it 'relates when persisted' do
        item = LineItem.new
        item.save(validate: false)

        order = Order.new
        order.save(validate: false)

        oli = OrderLineItem.new(order: order, line_item: item)
        oli.save(validate: false)

        item.reload
        related_order = item.orders.first
        expect(related_order).to eq order
      end
    end

    context 'purchasers' do

      it 'has purchasers' do
        skip('is there a way to make this work?')
        item = LineItem.new
        attendance = EventAttendance.new
        order = Order.new(attendance: attendance)
        oli = OrderLineItem.new(order: order, line_item: item)

        purchaser = item.purchasers.first
        expect(purchaser).to eq attendance
      end

      it 'relates when persisted' do
        item = LineItem.new
        item.save(validate: false)

        attendance = EventAttendance.new
        attendance.save(validate: false)

        order = Order.new(attendance: attendance)
        order.save(validate: false)

        oli = OrderLineItem.new(order: order, line_item: item)
        oli.save(validate: false)

        item.reload
        purchaser = item.purchasers.first
        expect(purchaser).to eq attendance
      end

    end

  end

end
