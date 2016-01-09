require 'rails_helper'

RSpec.describe Api::EventsController, type: :controller do


    before(:each) do
      login
    end

    context "#new" do

      it "has an event object" do
        get :new
        assigns(:event).should be_kind_of(Event)
      end
    end

    context "#create" do
      let(:pricing_tier){ build(:pricing_tier) }
      let(:event){ build(:event) }
      let(:valid_attributes){
        attrs = event.attributes.merge(opening_tier_attributes: pricing_tier.attributes)
        attrs.delete(:hosted_by_id)
        attrs
      }

      it "creates an event" do
        expect {
          post :create, { event: valid_attributes }
        }.to change(Event, :count)
      end

      it "creates the initial pricieng tier" do
        expect {
          post :create, { event: valid_attributes }
        }.to change(PricingTier, :count)

        Event.last.pricing_tiers.size.should == 1
      end

      it "event is assigned to the current user" do
        post :create, { event: valid_attributes }
        Event.last.hosted_by.should == @user
      end
    end

    context '#revenue' do
      before(:each) do
        @event = create(:event, hosted_by: @user)

        @attendance = create(:attendance, host: @event)
        @order = create(:order, attendance: @attendance, event: @event, paid: true)
        allow_any_instance_of(Order).to receive(:net_received){ 10 }
      end

      it 'attending attendance is included in total' do

        get :revenue, id: @event.id
        attendances = assigns(:attendances)
        expect(attendances).to include(@attendance)

        expect(assigns(:total)).to eq 10
      end

      it 'non-attending attendance is not included in total' do
        @attendance.destroy
        @attendance.save

        get :revenue, id: @event.id
        attendances = assigns(:attendances)
        expect(attendances).to_not include(@attendance)

        expect(assigns(:total)).to eq 0
      end

      it 'does not include unpaind, non-attending orders in unpaid revenue' do
        attendance = create(:attendance, event: @event)
        order = create(:order, attendance: attendance, event: @event)

        # make not attending
        attendance.destroy
        attendance.save

        get :revenue, id: @event.id
        expect(assigns(:owed)).to eq 0
        # verify that the total didn't also increase
        expect(assigns(:total)).to eq 10
      end

    end

    context "#update" do
      before(:each) do
        @event = create(:event, hosted_by: @user)
      end

      it "doesn't create a new pricing tier" do
        expect {
          put :update, id: @event.id, event: {opening_tier_attributes: { date: (@event.ends_at - 10.days).to_date }}
        }.to_not change(PricingTier, :count)
      end

      it "updates the pricing tier / registration start date" do
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
