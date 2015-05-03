require 'spec_helper'

describe HostedEvents::DiscountsController do

  before(:each) do
    login
    @event = create(:event, hosted_by: @user)
  end

  describe '#create' do

    it 'is tied to an event' do
      post :create, hosted_event_id: @event.id, discount: build(:discount).attributes
      d = Discount.last
      expect(d.event).to eq @event

      @event.reload
      expect(@event.discounts.last).to eq d
    end

    it 'creates a discount' do
      expect{
        post :create, hosted_event_id: @event.id, discount: build(:discount).attributes
      }.to change(Discount, :count).by(1)

    end

  end

end
