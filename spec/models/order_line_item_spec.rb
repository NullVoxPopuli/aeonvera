require 'spec_helper'

describe OrderLineItem do

  describe 'validations' do

    context 'partner_name' do
      it 'has a line item with a competition' do
        comp = Competition.new(kind: Competition::TEAM)
        oli = OrderLineItem.new(line_item: comp)

        oli.valid?
        expect(oli.errors[:partner_name]).to be_blank
      end

      it 'has a strictly competition' do
        comp = Competition.new(kind: Competition::STRICTLY)
        oli = OrderLineItem.new(line_item: comp)

        oli.valid?
        expect(oli.errors[:partner_name]).to be_present
      end
    end

    context 'dancer_orientation' do
      it 'has a line item with a competition' do
        comp = Competition.new(kind: Competition::TEAM)
        oli = OrderLineItem.new(line_item: comp)

        oli.valid?
        expect(oli.errors[:dancer_orientation]).to be_blank
      end

      it 'has a jack and jill' do
        comp = Competition.new(kind: Competition::JACK_AND_JILL)
        oli = OrderLineItem.new(line_item: comp)

        oli.valid?
        expect(oli.errors[:dance_orientation]).to be_present
      end
    end
  end
end
