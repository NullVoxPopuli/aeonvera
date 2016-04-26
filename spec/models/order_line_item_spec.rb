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
  end
end
