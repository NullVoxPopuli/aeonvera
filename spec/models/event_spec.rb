require "spec_helper"

describe Event do
  context "aggregates" do
    context "#shirts_sold" do

    end
  end

  context 'validate unique domain' do
    let(:event){ create_event }
    let(:event2){ create_event }

    it 'has a different domain from a previous event' do
      event.update!(domain: 'my')
      event2.update!(domain: 'my2')

      expect(event2.valid?).to eq true
    end

    it 'has the same domain as a previous event' do
      event.update!(domain: 'my')
      event2.domain = 'my'

      expect(event2).to_not be_valid
      expect(event2.errors.full_messages.first).to include("is taken")
    end

    it 'has the same domain as an organization' do
      organization = create(:organization)
      event.domain = organization.domain

      expect(event).to_not be_valid
      expect(event.errors.full_messages.first).to include("is taken")
    end

    it 'can have the same domain as a previously ended event' do
      create(:event, ends_at: 1.week.ago, starts_at: 2.weeks.ago, domain: "my")
      event2.domain = 'my'

      expect(event2).to be_valid
    end
  end

  context "pricing_tiers" do
    it "is instantiated with one pricing tier" do
      pending "right now, this is handled with accepts_nested_attributes_for need to investigate if we want a before_create hook as well"
      fail
    end


    context "#current_tier" do
      let(:event){ create_event }

      it "retrieves the first tier when only one tier exists" do
        event.current_tier.should == event.pricing_tiers.first
      end

      it "retrieves the most recent tier of 2" do
        tier = create(:pricing_tier, event: event, date: (event.opening_tier.date + 1.day).to_date)
        event.current_tier.should_not == event.opening_tier
        event.current_tier.should == tier
      end

      it "doesn't select tiers that occur after today (even if the date distance is closer)" do
        tier = create(:pricing_tier, event: event, date: (event.opening_tier.date + 1.day).to_date)
        future = create(:pricing_tier, event: event, date: (Date.today + 10.day).to_date)

        event.current_tier.should_not == event.opening_tier
        event.current_tier.should_not == future
        event.current_tier.should == tier
      end

      it "selects the last tier" do
        tier = create(:pricing_tier, event: event, date: Date.today - 3.day)
        middle = create(:pricing_tier, event: event, date: Date.today - 2.day)
        last = create(:pricing_tier, event: event, date: Date.today - 1.day)


        event.current_tier.should_not == event.opening_tier
        event.current_tier.should_not == tier
        event.current_tier.should_not == middle
        event.current_tier.should == last
      end
    end

  end
end
