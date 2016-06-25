require 'spec_helper'

describe OrderLineItem do
  describe 'validations' do

    context 'line_item host must match order host' do

      it 'has a competition and order from different events' do
        comp = Competition.new(event: Event.new)
        order = Order.new(host: Event.new)
        oli = OrderLineItem.new(line_item: comp, order: order)

        expect(oli).to_not be_valid
        expect(oli.errors.full_messages).to_not be_blank
      end

      it 'has a matching event' do
        event = Event.new
        comp = Competition.new(event: event)
        order = Order.new(host: event)
        oli = OrderLineItem.new(line_item: comp, order: order)

        expect(oli).to be_valid
        expect(oli.errors.full_messages).to be_blank
      end

    end

    context 'partner_name' do
      it 'has a line item with a competition' do
        order = Order.new(host: Event.new)
        comp = Competition.new(kind: Competition::TEAM, event: order.host)
        oli = OrderLineItem.new(line_item: comp, order: order)

        oli.valid?
        expect(oli.errors[:partner_name]).to be_blank
      end

      it 'has a strictly competition' do
        order = Order.new(host: Event.new)
        comp = Competition.new(kind: Competition::STRICTLY, event: order.host)
        oli = OrderLineItem.new(line_item: comp, order: order)

        oli.valid?
        expect(oli.errors[:partner_name]).to be_present
      end
    end

    context 'dancer_orientation' do
      it 'has a line item with a competition' do
        order = Order.new(host: Event.new)
        comp = Competition.new(kind: Competition::TEAM, event: order.host)
        oli = OrderLineItem.new(line_item: comp, order: order)

        oli.valid?
        expect(oli.errors[:dancer_orientation]).to be_blank
      end

      it 'has a jack and jill' do
        order = Order.new(host: Event.new)
        comp = Competition.new(kind: Competition::JACK_AND_JILL, event: order.host)
        oli = OrderLineItem.new(line_item: comp, order: order)

        oli.valid?
        expect(oli.errors[:dance_orientation]).to be_present
      end
    end

    context 'cannot have the same line_item ref as other order_line_item' do
      it 'does not save' do
        package = create(:package)
        order = create(:order, host: package.event, attendance: create(:attendance))
        create(:order_line_item, line_item: package, order: order)
        expect {
          create(:order_line_item, line_item: package, order: order)
        }.to raise_error
        order.reload

        expect(order.order_line_items.length).to eq 1
      end

      it 'allows adding a different order' do
        package = create(:package)
        order = create(:order, host: package.event, attendance: create(:attendance))
        order2 = create(:order, host: package.event, attendance: create(:attendance))
        expect {
          create(:order_line_item, line_item: package, order: order)
          create(:order_line_item, line_item: package, order: order2)
        }.to change(OrderLineItem, :count).by 2
      end
    end
  end
end
