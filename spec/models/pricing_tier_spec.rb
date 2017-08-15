# frozen_string_literal: true

# == Schema Information
#
# Table name: pricing_tiers
#
#  id                  :integer          not null, primary key
#  increase_by_dollars :decimal(, )      default(0.0)
#  date                :datetime
#  registrants         :integer
#  event_id            :integer
#  deleted_at          :datetime
#
# Indexes
#
#  index_pricing_tiers_on_event_id  (event_id)
#

require 'spec_helper'

describe PricingTier do
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  let(:opening_tier) {
    o = event.opening_tier
    o.date = 100.days.ago
    o.save
    o
  }
  let(:pt) { PricingTier.new(event: event) }

  it 'has an opening tier' do
    expect(pt).to_not eq event.opening_tier
  end

  describe '#price_of' do
    let(:package) { create(:package, event: event, initial_price: 10) }

    context 'event.current_tier == event.opening_tier' do
      before(:each) do
        @current_tier = event.current_tier
        expect(@current_tier).to eq opening_tier
        pt.date = 2.days.from_now
        pt.increase_by_dollars = 5
        pt.save
        # reload because the event's memoization needs updating
        pt.reload
      end

      it 'gets the price at the opening tier' do
        actual = @current_tier.price_of(package)
        expect(actual).to eq package.initial_price
      end

      it 'gets the price at a future tier' do
        actual = pt.price_of(package)
        expect(actual).to eq package.initial_price + pt.increase_by_dollars
      end
    end

    context 'event.current_tier != event.opening_tier' do
      before(:each) do
        pt.date = 1.day.from_now
        pt.increase_by_dollars = 3
        pt.save
        Delorean.jump 4.days

        event.reload
        expect(event.pricing_tiers.count).to eq 2
        expect(event.current_tier).to_not eq event.opening_tier
        expect(event.current_tier).to eq pt

        @current_tier = event.current_tier
        @opening_tier = opening_tier
      end

      after(:each) do
        Delorean.back_to_the_present
      end

      it 'gets the price at the opening tier' do
        actual = @opening_tier.price_of(package)
        expect(actual).to eq package.initial_price
      end

      it 'gets the price at the current tier' do
        actual = @current_tier.price_of(package)
        expect(actual).to eq package.initial_price + pt.increase_by_dollars
      end
    end
  end

  context '#date' do
    context 'invalid' do
      after(:each) do
        pt.valid?
        pt.errors.full_messages.size.should == 1
        pt.errors.keys.should include(:date)
        error = I18n.t('activerecord.errors.models.pricing_tier.attributes.date.invalid_date')
        pt.errors.full_messages.first.should include(error)
      end

      it "shouldn't allow to be after registration closes" do
        pt.date = event.ends_at
      end
    end

    it 'should allow the after date to be the same as when registration opens' do
      pending 'we need to test the initial creation of a pricieng tier when creating an event'
      raise
      pt.date = Date.tomorrow
      pt.valid?.should == true
    end
  end

  context '#previous_pricing_tiers' do
    it 'returns the previous pricing tiers' do
      pt.date = Date.tomorrow + 7.days
      pt.save
      pt2 = create(:pricing_tier, event: event, date: pt.date - 1.day)
      pt.previous_pricing_tiers.should include(pt2)
    end

    it 'should return empty array if the current tier is the first tier' do
      pt = event.current_tier
      pt2 = create(:pricing_tier, event: event, date: pt.date + 1.day)

      expect(pt.previous_pricing_tiers).to_not include(pt)
      expect(pt.previous_pricing_tiers).to be_empty
    end

    it 'returns multiple previous pricing tiers' do
      pt.date = Date.tomorrow + 7.days
      pt.save
      pt2 = create(:pricing_tier, event: event, date: pt.date - 1.day)
      pt3 = create(:pricing_tier, event: event, date: pt.date - 2.days)
      pt.previous_pricing_tiers.should include(pt2)
      pt.previous_pricing_tiers.should include(pt3)
    end
  end

  context '#current_price' do
    let(:package) { create(:package, event: event) }

    before(:each) do
      pt.increase_by_dollars = 10
    end

    it 'calculates the current price of a package' do
      pt.date = Date.tomorrow - 10.days
      pt.save
      expect(pt.current_price(package)).to eq package.initial_price + pt.increase_by_dollars
    end

    it "does not include a pricieng tier because it hasn't occurred yet" do
      pt.date = Date.tomorrow + 10.days
      allow(event).to receive(:current_price) { event.opening_tier }
      expect(pt.current_price(package)).to eq package.initial_price
    end

    context 'tier based on number of registrants' do
      before(:each) do
        pt.registrants = 10
        pt.save
      end

      it 'calculates current price of a package' do
        allow_any_instance_of(Event).to receive(:registrations) { double(count: 20) }
        expect(package.current_price).to eq package.initial_price + pt.increase_by_dollars
      end

      it 'calculates with multiple total number tiers' do
        # The Delorean replicates a long lasting issue that Travis discovered
        Delorean.time_travel_to(10.days.from_now) do
          pt2 = create(:pricing_tier, event: event, registrants: 20, date: nil)
          pt3 = create(:pricing_tier, event: event, registrants: 40, date: nil)

          20.times do
            create(:registration, event: event)
          end

          expect(pt.should_apply_amount?).to eq true
          expect(pt2.should_apply_amount?).to eq true
          expect(pt3.should_apply_amount?).to eq false

          expect(event.current_tier).to eq pt2

          # pt3 should not be recognized yet
          result = package.current_price
          expect(result).to eq (
            package.initial_price + pt.increase_by_dollars + pt2.increase_by_dollars
          )
        end
      end
    end

    context 'tier based on date' do
      before(:each) do
        pt.date = Date.tomorrow - 10.days
        pt.save
      end

      it 'calculates the price based on previous pricing tiers' do
        pt2 = create(:pricing_tier, event: event, date: pt.date - 4.days)

        pt.current_price(package).should == (
          package.initial_price + pt.increase_by_dollars + pt2.increase_by_dollars
        )
      end

      it 'calculates the price based on the last pricing tier' do
        pt2 = create(:pricing_tier, event: event, date: pt.date - 3.days)
        pt3 = create(:pricing_tier, event: event, date: pt.date - 4.days)

        pt.current_price(package).should == (
          package.initial_price + pt.increase_by_dollars +
          pt2.increase_by_dollars + pt3.increase_by_dollars
        )
      end
    end

    context 'tier has set date and total registrants' do
      it 'date comes first' do
        pt.registrants = 10
        pt.date = Date.tomorrow - 10.days
        pt.save
        pt.current_price(package).should == (
          package.initial_price + pt.increase_by_dollars
        )
      end

      it 'total comes first' do
        pt.registrants = 10
        pt.date = Date.tomorrow + 10.days
        pt.save

        11.times do
          create(:registration, event: event)
        end

        pt.current_price(package).should == (
          package.initial_price + pt.increase_by_dollars
        )
      end
    end

    context 'mixed tier scheme' do
      it 'starts with total registrants and later recognizes a date' do
        pt.registrants = 10
        pt.save
        pt2 = create(:pricing_tier, event: event, date: Date.today - 30.days)

        11.times do
          create(:registration, event: event)
        end
        #
        # # reload due to memoization
        # pt.reload
        pt.current_price(package).should == (
          package.initial_price + pt.increase_by_dollars +
          pt2.increase_by_dollars
        )
      end
    end
  end
end
