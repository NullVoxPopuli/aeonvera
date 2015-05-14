require "spec_helper"

describe PricingTier do

  let(:user){ create(:user) }
  let(:event){ create(:event) }
  let(:opening_tier){
    o = event.opening_tier
    o.date = 100.days.ago
    o.save
    o
  }
  let(:pt){ PricingTier.new(event: event) }

  it 'has an opening tier' do
    expect(pt).to_not eq event.opening_tier
  end

  context "#date" do

    context "invalid" do
      after(:each) do
        pt.valid?
        pt.errors.full_messages.size.should == 1
        pt.errors.keys.should include(:date)
        error = I18n.t("activerecord.errors.models.pricing_tier.attributes.date.invalid_date")
        pt.errors.full_messages.first.should include(error)
      end

      it "shouldn't allow to be after registration closes" do
        pt.date = event.ends_at
      end
    end

    it "should allow the after date to be the same as when registration opens" do
      pending "we need to test the initial creation of a pricieng tier when creating an event"
      fail
      pt.date = Date.tomorrow
      pt.valid?.should == true
    end

  end

  context "#previous_pricing_tiers" do

    it "returns the previous pricing tiers" do
      pt.date = Date.tomorrow + 7.days
      pt2 = create(:pricing_tier, event: event, date: pt.date - 1.day)
      pt.previous_pricing_tiers.should include(pt2)
    end

    it "should return empty array if the current tier is the first tier" do
      pt = event.current_tier
      pt2 = create(:pricing_tier, event: event, date: pt.date + 1.day)
      expect(pt.previous_pricing_tiers).to_not include(pt)
      expect(pt.previous_pricing_tiers).to be_empty
    end

    it "returns multiple previous pricing tiers" do
      pt.date = Date.tomorrow + 7.days
      pt2 = create(:pricing_tier, event: event, date: pt.date - 1.day)
      pt3 = create(:pricing_tier, event: event, date: pt.date - 2.days)
      pt.previous_pricing_tiers.should include(pt2)
      pt.previous_pricing_tiers.should include(pt3)
    end
  end


  context "#current_price" do
    let(:package){ create(:package, event: event) }

    before(:each) do
      pt.increase_by_dollars = 10
    end

    it "calculates the current price of a package" do
      pt.date = Date.tomorrow - 10.days
      expect(pt.current_price(package)).to eq package.initial_price + pt.increase_by_dollars
    end

    it "does not include a pricieng tier because it hasn't occurred yet" do
      pt.date = Date.tomorrow + 10.days
      allow(event).to receive(:current_price){ event.opening_tier }
      expect(pt.current_price(package)).to eq package.initial_price
    end

    context 'tier based on number of registrants' do
      before(:each) do
        pt.registrants = 10
        pt.save
      end

      it 'calculates current price of a package' do
        allow_any_instance_of(Event).to receive(:attendances){ double(count: 20)}
        expect(package.current_price).to eq package.initial_price + pt.increase_by_dollars
      end

      it 'calculates with multiple total number tiers' do
        # allow(event).to receive(:attendances){ double(count: 30, where: Array.new(30, true)) }
        # allow(event).to receive(:attendances){ double(count: 20)}
        # allow(package).to receive(:event){ event }
        pt2 = create(:pricing_tier, event: event, registrants: 20)
        pt3 = create(:pricing_tier, event: event, registrants: 40)
        allow_any_instance_of(Event).to receive(:attendances){ double(count: 20)}

        expect(pt2.should_apply_amount?).to eq true
        expect(pt3.should_apply_amount?).to eq false

        expect(event.current_tier).to eq pt2

        # pt3 should not be recognized yet
        expect(package.current_price).to eq (
          package.initial_price + pt.increase_by_dollars + pt2.increase_by_dollars
        )
      end
    end

    context 'tier based on date' do
      before(:each) do
        pt.date = Date.tomorrow - 10.days
      end

      it "calculates the price based on previous pricing tiers" do
        pt2 = create(:pricing_tier, event: event, date: pt.date - 4.days)

        pt.current_price(package).should == (
          package.initial_price + pt.increase_by_dollars + pt2.increase_by_dollars
        )
      end

      it "calculates the price based on the last pricing tier" do
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

        pt.current_price(package).should == (
          package.initial_price + pt.increase_by_dollars
        )
      end

      it 'total comes first' do
        pt.registrants = 10
        pt.date = Date.tomorrow + 10.days
        allow(event).to receive(:attendances){ double(count: 30, where: Array.new(30, true)) }

        pt.current_price(package).should == (
          package.initial_price + pt.increase_by_dollars
        )
      end

    end

    context 'mixed tier scheme' do
      it 'starts with total registrants and later recognizes a date' do
        pt.registrants = 10
        pt2 = create(:pricing_tier, event: event, date: Date.today - 30.days)
        allow(event).to receive(:attendances){ double(count: 30, where: Array.new(30, true)) }

        pt.current_price(package).should == (
          package.initial_price + pt.increase_by_dollars +
          pt2.increase_by_dollars
        )

      end
    end
  end

end
