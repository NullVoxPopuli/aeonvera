# == Schema Information
#
# Table name: events
#
#  id                              :integer          not null, primary key
#  name                            :string(255)      not null
#  short_description               :string(255)
#  domain                          :string(255)      not null
#  starts_at                       :datetime         not null
#  ends_at                         :datetime         not null
#  mail_payments_end_at            :datetime
#  electronic_payments_end_at      :datetime
#  refunds_end_at                  :datetime
#  has_volunteers                  :boolean          default(FALSE), not null
#  volunteer_description           :string(255)
#  housing_status                  :integer          default(0), not null
#  housing_nights                  :string(255)      default("5,6")
#  hosted_by_id                    :integer
#  deleted_at                      :datetime
#  created_at                      :datetime
#  updated_at                      :datetime
#  allow_discounts                 :boolean          default(TRUE), not null
#  payment_email                   :string(255)      default(""), not null
#  beta                            :boolean          default(FALSE), not null
#  shirt_sales_end_at              :datetime
#  show_at_the_door_prices_at      :datetime
#  allow_combined_discounts        :boolean          default(TRUE), not null
#  location                        :string(255)
#  show_on_public_calendar         :boolean          default(TRUE), not null
#  make_attendees_pay_fees         :boolean          default(TRUE), not null
#  accept_only_electronic_payments :boolean          default(FALSE), not null
#  logo_file_name                  :string(255)
#  logo_content_type               :string(255)
#  logo_file_size                  :integer
#  logo_updated_at                 :datetime
#  registration_email_disclaimer   :text
#  legacy_housing                  :boolean          default(FALSE), not null
#  ask_if_leading_or_following     :boolean          default(TRUE), not null
#  contact_email                   :string
#  online_competition_sales_end_at :datetime
#
# Indexes
#
#  index_events_on_domain  (domain)
#

require "spec_helper"

describe Event do

  describe '#url' do
    it 'is no longer a subdomain' do
      event = Event.new(subdomain: 'test123')
      expect(event.url).to end_with('test123')
    end

    it 'starts with the domain' do
      event = Event.new(subdomain: 'test123')
      expect(event.url).to start_with '//' + APPLICATION_CONFIG[:domain][Rails.env]
    end
  end

  context "aggregates" do
    context "#shirts_sold" do

    end
  end

  describe 'validation' do
    describe 'domain' do
      it 'cannot be a blacklisted word' do
        event = build(:event, domain: 'hosted-events')
        expect(event.valid?).to eq false
        expect(event.errors.keys).to include(:domain)
      end
    end
  end

  describe :is_accessible_to? do
    let(:event){ create_event }

    it 'is if hosting' do
      expect(event.is_accessible_to?(event.hosted_by)).to eq true
    end

    it 'is if collaborating' do
      user = create(:user)
      Collaboration.new(collaborated: event, user: user).save!
      expect(event.is_accessible_to?(user)).to eq true
    end

    it 'is if registered' do
      user = create(:user)
      registration = create(:registration, event: event, attendee: user)
      expect(event.is_accessible_to?(user)).to eq true
    end

    it 'is not' do
      expect(event.is_accessible_to?(create(:user))).to eq false
    end
  end

  describe '#pricing_tiers_in_order' do
    let(:event){ create_event }

    it 'puts the opening tier at the beginning' do
      create(:pricing_tier, event: event, registrants: 20)
      create(:pricing_tier, event: event, date: 10.days.from_now)
      opening_tier = event.opening_tier

      tiers = event.pricing_tiers_in_order

      expect(tiers.first).to eq opening_tier
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
      tier = build(:pricing_tier)
      event = build(:event, ends_at: 1.week.ago, starts_at: 2.weeks.ago, domain: "my", opening_tier: tier)
      event.save

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
      let(:opening_tier){ event.opening_tier }

      context 'by date' do
        it "retrieves the first tier when only one tier exists" do
          event.current_tier.should == event.pricing_tiers.first
        end

        it "retrieves the most recent tier of 2" do
          opening_tier.date = 3.days.ago
          opening_tier.save

          tier = create(:pricing_tier, event: event, date: Time.now)
          event.current_tier.should_not == event.opening_tier
          event.current_tier.should == tier
        end

        it "doesn't select tiers that occur after today (even if the date distance is closer)" do
          opening_tier.date = 3.days.ago
          opening_tier.save

          tier = create(:pricing_tier, event: event, date: Time.now.to_date)
          future = create(:pricing_tier, event: event, date: Time.now.to_date + 10.day)

          event.current_tier.should_not == opening_tier
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

      context 'by registrants' do
        it 'first tier is opening tier' do
          tier = create(:pricing_tier, event: event, registrants: 3, date: nil)

          expect(event.current_tier).to eq opening_tier
        end

        it 'advances to the next tier' do
          tier = create(:pricing_tier, event: event, registrants: 3, date: nil)

          3.times do
            create(:registration, event: event)
          end

          expect(event.current_tier).to_not eq opening_tier
          expect(event.current_tier).to eq tier
        end

        it 'has not yet advanced to a tier' do
          active = create(:pricing_tier, event: event, registrants: 3, date: nil)
          current = create(:pricing_tier, event: event, registrants: 10, date: nil)
          future = create(:pricing_tier, event: event, registrants: 16, date: nil)

          12.times do
            create(:registration, event: event)
          end

          expect(event.current_tier).to_not eq opening_tier
          expect(event.current_tier).to_not eq active
          expect(event.current_tier).to_not eq future
          expect(event.current_tier).to eq current
        end

        it 'is in the last tier' do
          active = create(:pricing_tier, event: event, registrants: 3, date: nil)
          last = create(:pricing_tier, event: event, registrants: 10, date: nil)
          current = create(:pricing_tier, event: event, registrants: 16, date: nil)

          16.times do
            create(:registration, event: event)
          end

          expect(event.current_tier).to_not eq opening_tier
          expect(event.current_tier).to_not eq active
          expect(event.current_tier).to_not eq last
          expect(event.current_tier).to eq current
        end
      end

      context 'by either registrants or by date' do
        it 'first tier is opening tier' do

        end

        it 'advances to the next tier' do

        end

        it 'has not yet advanced to a tier' do

        end

        it 'is in the last tier' do

        end
      end
    end

  end
end
