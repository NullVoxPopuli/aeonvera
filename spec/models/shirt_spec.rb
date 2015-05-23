require 'spec_helper'


describe LineItem::Shirt do

  describe '#price_for_size' do

    let(:shirt){ create(:shirt) }

    it 'gets the price for a size' do
      shirt.metadata['prices'] ||= {}
      shirt.metadata['prices']['XL'] = 30
      actual = shirt.price_for_size('XL')
      expect(actual).to eq 30
    end

  end

end
