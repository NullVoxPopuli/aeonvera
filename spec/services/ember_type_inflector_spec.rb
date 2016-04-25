require 'spec_helper'

describe EmberTypeInflector do

  describe '.ember_type_to_rails' do
    let(:m) do
      ->(ember_type) do
        EmberTypeInflector.ember_type_to_rails(ember_type)
      end
    end

    it{ expect(m.('packages')).to eq Package.name }
    it{ expect(m.('competitions')).to eq Competition.name }
    it{ expect(m.('shirts')).to eq LineItem::Shirt.name }
    it{ expect(m.('line-items')).to eq LineItem.name }
    it{ expect(m.('raffle-tickets')).to eq LineItem::RaffleTicket.name }
  end

end
