# == Schema Information
#
# Table name: line_items
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  price                  :decimal(, )
#  host_id                :integer
#  deleted_at             :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  item_type              :string(255)
#  picture_file_name      :string(255)
#  picture_content_type   :string(255)
#  picture_file_size      :integer
#  picture_updated_at     :datetime
#  reference_id           :integer
#  metadata               :text
#  expires_at             :datetime
#  host_type              :string(255)
#  description            :text
#  schedule               :text
#  starts_at              :time
#  ends_at                :time
#  duration_amount        :integer
#  duration_unit          :integer
#  registration_opens_at  :datetime
#  registration_closes_at :datetime
#  becomes_available_at   :datetime
#  initial_stock          :integer          default(0), not null
#
# Indexes
#
#  index_line_items_on_host_id_and_host_type                (host_id,host_type)
#  index_line_items_on_host_id_and_host_type_and_item_type  (host_id,host_type,item_type)
#

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
        registration = Registration.new
        order = Order.new(registration: registration)
        oli = OrderLineItem.new(order: order, line_item: item)

        order.order_line_items = [oli]
        item.orders = [order]
        item.order_line_items = [oli]

        purchaser = item.purchasers.first
        expect(purchaser).to eq registration
      end

      it 'relates when persisted' do
        item = LineItem.new
        item.save(validate: false)

        registration = Registration.new
        registration.save(validate: false)

        order = Order.new(registration: registration)
        order.save(validate: false)

        oli = OrderLineItem.new(order: order, line_item: item)
        oli.save(validate: false)

        item.reload
        purchaser = item.purchasers.first
        expect(purchaser).to eq registration
      end

    end

  end

end
