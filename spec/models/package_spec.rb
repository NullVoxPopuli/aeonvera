require "spec_helper"

describe @package do

  before(:each) do
    @user = create(:user)
    @event = create(:event, user: @user)
    @package = create(:package, event: @event, initial_price: 10, at_the_door_price: 50)
  end

  context "#current_price" do

    it 'is the initial price' do
      expect(@package.current_price).to eq @package.initial_price
    end

    it "changes based on the date" do
      tier = create(:pricing_tier, date: 1.day.ago, event: @event)
      expected = @package.initial_price + tier.increase_by_dollars
      expect(@package.current_price).to eq expected
    end

    it "changes based on the number of registrants for this event" do
      tier = create(:pricing_tier, registrants: 10, event: @event)
      allow_any_instance_of(Event).to receive(:attendances){ double(count: 20)}

      expected = @package.initial_price + tier.increase_by_dollars
      expect(@package.current_price).to eq expected
    end

    it 'does not change if the tiers are not yet eligible' do
      tier = create(:pricing_tier, date: 19.days.from_now, event: @event)
      tier2 = create(:pricing_tier, registrants: 10, event: @event)
      expect(@package.current_price).to eq @package.initial_price
    end

    it 'changes base on two tiers' do
      tier = create(:pricing_tier, date: 1.day.ago, event: @event)
      tier2 = create(:pricing_tier, registrants: 10, event: @event)
      allow_any_instance_of(Event).to receive(:attendances){ double(count: 20)}

      expected = @package.initial_price + tier.increase_by_dollars + tier2.increase_by_dollars
      expect(@package.current_price).to eq expected

    end

    context 'optionally does not change based on passing tiers' do
      before(:each) do
        @package.ignore_pricing_tiers = true
      end

      it 'tier by date passes' do
        tier = create(:pricing_tier, date: Date.today, event: @event)
        expected = @package.initial_price
        expect(@package.current_price).to eq expected
      end

    end

  end

  context "#price_at_tier" do

    it 'redirects functionality to the tier' do
      tier = create(:pricing_tier, date: Date.today, event: @event)

      expect(tier).to receive(:price_of)
      @package.price_at_tier(tier)
    end

    it 'correctly calculates the value' do
      tier = create(:pricing_tier, registrants: 2, event: @event)
      allow(tier).to receive(:should_apply_amount?){ true }
      allow(@event).to receive(:pricing_tiers){ [tier] }

      expected = @package.initial_price + tier.amount
      expect(@package.price_at_tier(tier)).to eq expected
    end
  end
end
