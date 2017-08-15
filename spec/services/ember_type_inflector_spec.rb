# frozen_string_literal: true

require 'spec_helper'

describe EmberTypeInflector do
  describe '.ember_type_to_rails' do
    let(:m) do
      ->(ember_type) do
        EmberTypeInflector.ember_type_to_rails(ember_type)
      end
    end

    it { expect(m.call('packages')).to eq Package.name }
    it { expect(m.call('competitions')).to eq Competition.name }
    it { expect(m.call('shirts')).to eq LineItem::Shirt.name }
    it { expect(m.call('line-items')).to eq LineItem.name }
    it { expect(m.call('raffle-tickets')).to eq LineItem::RaffleTicket.name }
  end
end
