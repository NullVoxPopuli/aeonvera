require 'spec_helper'

describe Restraint do


  context 'a tier affects packages' do
    let(:event){ create(:event) }
    let(:package){ create(:package, event: event) }
    let(:tier){ create(:pricing_tier, date: Date.tomorrow, event: event) }

    context 'without restraint' do
      context '#current_price' do
        it 'does not affect the unaffected package' do
          Delorean.time_travel_to('2 days from now') do
            actual = package.current_price
            expected = package.initial_price

            expect(actual).to eq expected
          end
        end
      end

      context '#price_at_tier' do
        it 'does not affect the unaffected package' do
          Delorean.time_travel_to('2 days from now') do
            actual = package.price_at_tier(tier)
            expected = package.initial_price

            expect(actual).to eq expected
          end
        end
      end

    end

    context 'with restraint' do

      before(:each) do
        create(:restraint, restrictable: package, dependable: tier)
      end
      
      context '#current_price' do
        it 'increments the affected package' do
          Delorean.time_travel_to('2 days from now') do
            actual = package.current_price
            expected = package.initial_price + tier.increase_by_dollars

            expect(actual).to eq expected
          end
        end
      end

      context '#price_at_tier' do
        it 'increments the affected package' do
          Delorean.time_travel_to('2 days from now') do
            actual = package.price_at_tier(tier)
            expected = package.initial_price + tier.increase_by_dollars

            expect(actual).to eq expected
          end
        end
      end
    end
  end
end
