# frozen_string_literal: true
# == Schema Information
#
# Table name: packages
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  initial_price        :decimal(, )
#  at_the_door_price    :decimal(, )
#  attendee_limit       :integer
#  expires_at           :datetime
#  requires_track       :boolean
#  event_id             :integer
#  created_at           :datetime
#  updated_at           :datetime
#  deleted_at           :datetime
#  ignore_pricing_tiers :boolean          default(FALSE), not null
#  description          :text
#
# Indexes
#
#  index_packages_on_event_id  (event_id)
#

require 'spec_helper'

describe Package do
  let(:user) { create(:user) }
  let(:event) { create(:event, user: user) }
  let(:package) { create(:package, event: event, initial_price: 10, at_the_door_price: 50) }

  context '#current_price' do
    before(:each) do
      # set openieng tier before any tiers created here
      o = event.opening_tier
      o.date = 1.week.ago
      o.increase_by_dollars = 0
      o.save
    end

    it 'is the initial price' do
      expect(package.current_price).to eq package.initial_price
    end

    it 'changes based on the date' do
      tier = create(:pricing_tier, date: 2.day.ago, event: event)
      expected = package.initial_price + tier.increase_by_dollars
      expect(package.current_price).to eq expected
    end

    it 'changes based on the number of registrants for this event' do
      tier = create(:pricing_tier, registrants: 10, event: event)
      20.times do
        create(:registration, event: event)
      end

      expected = package.initial_price + tier.increase_by_dollars
      expect(package.current_price).to eq expected
    end

    it 'does not change if the tiers are not yet eligible' do
      event.registrations.destroy_all

      # The Delorean replicates a long lasting issue that Travis discovered
      Delorean.time_travel_to(10.days.from_now) do
        tier = create(:pricing_tier, date: 19.days.from_now, event: event)
        tier2 = create(:pricing_tier, registrants: 10, event: event, date: nil)

        expect(event.current_tier).to eq event.opening_tier
        expect(package.current_price).to eq package.initial_price
      end
    end

    it 'changes base on two tiers' do
      tier = create(:pricing_tier, registrants: 10, event: event, date: nil)
      tier2 = create(:pricing_tier, date: 2.day.ago, event: event)

      11.times do
        create(:registration, event: event)
      end

      expect(event.current_tier).to eq tier2

      expected = package.initial_price + tier.increase_by_dollars + tier2.increase_by_dollars
      expect(package.current_price).to eq expected
    end

    context 'optionally does not change based on passing tiers' do
      before(:each) do
        package.ignore_pricing_tiers = true
      end

      it 'tier by date passes' do
        tier = create(:pricing_tier, date: Date.today, event: event)
        expected = package.initial_price
        expect(package.current_price).to eq expected
      end
    end
  end

  context '#price_at_tier' do
    it 'redirects functionality to the tier' do
      tier = create(:pricing_tier, date: Date.today, event: event)

      expect(tier).to receive(:price_of)
      package.price_at_tier(tier)
    end

    it 'correctly calculates the value' do
      tier = create(:pricing_tier, registrants: 2, event: event)
      allow(tier).to receive(:should_apply_amount?) { true }
      allow(event).to receive(:pricing_tiers) { [tier] }

      expected = package.initial_price + tier.amount
      expect(package.price_at_tier(tier)).to eq expected
    end

    context 'a new tier is current' do
      before(:each) do
        @new_tier = create(:pricing_tier,
                           event: event,
                           date: 1.day.from_now,
                           increase_by_dollars: 3)

        Delorean.jump 4.days

        event.reload
        expect(event.pricing_tiers.count).to eq 2
        expect(event.current_tier).to_not eq event.opening_tier
        expect(event.current_tier).to eq @new_tier
      end

      after(:each) do
        Delorean.back_to_the_present
      end

      it 'reflects the price of a previous tier' do
        expected = package.initial_price
        expect(package.price_at_tier(event.opening_tier)).to eq expected
      end
    end
  end
end
