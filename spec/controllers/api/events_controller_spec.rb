require 'rails_helper'

RSpec.describe Api::EventsController, type: :controller do
    before(:each) do
      login_through_api
    end

    context "#new" do
      it "has an event object" do
        skip('test not json-api')

        get :new
        assigns(:event).should be_kind_of(Event)
      end
    end

    context "#create" do
      let(:event){ build(:event) }
      let(:pricing_tier){ build(:pricing_tier) }
      let(:valid_attributes){
        attrs = event.attributes.merge(opening_tier_attributes: pricing_tier.attributes)
        attrs.delete(:hosted_by_id)
        attrs
      }

      it "creates an event" do
        # skip('need to figure out how to send opening tier data')

        json_api = {
          "data" => {
            "attributes" => valid_attributes,
          "type" => "events"
          }
        }

        expect {
          post :create, json_api
        }.to change(Event, :count)
      end

      it "creates the initial pricieng tier" do

        json_api = {
          "data" => {
            "attributes" => valid_attributes,
          "type" => "events"
          }
        }

        expect {
          post :create, json_api
        }.to change(PricingTier, :count)

        Event.last.pricing_tiers.size.should == 1
      end

      it "event is assigned to the current user" do

        json_api = {
          "data" => {
            "attributes" => valid_attributes,
          "type" => "events"
          }
        }
        post :create, json_api
        expect(Event.last.hosted_by).to eq @user
      end
    end

    context "#update" do
      before(:each) do
        @event = create(:event, hosted_by: @user)
      end

      it "doesn't create a new pricing tier" do
        skip('test not json-api')
        expect {
          put :update, id: @event.id, event: {opening_tier_attributes: { date: (@event.ends_at - 10.days).to_date }}
        }.to_not change(PricingTier, :count)
      end

      it "updates the pricing tier / registration start date" do
        skip('test not json-api')

        expect(@event.pricing_tiers.count).to eq 1
        expect(@event.pricing_tiers.first).to eq @event.opening_tier

        expect{
          put :update,
          id: @event.id,
          event: @event.attributes.merge(
            opening_tier_attributes: {
              date: (@event.ends_at - 10.days).to_date
            }
          )
        }.to_not change(PricingTier, :count)

        event = Event.find(@event.id)
        event.opening_tier.date.to_date.should == (event.ends_at - 10.days).to_date
      end
    end

end
