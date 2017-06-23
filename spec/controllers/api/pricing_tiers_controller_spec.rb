require 'rails_helper'

describe Api::PricingTiersController, type: :controller do
  let(:user)  { create_confirmed_user }
  before(:each) do
    login_through_api
  end

  context 'index' do
    it 'gets all pricing_tiers' do
      event = create(:event, user: user)
      create(:pricing_tier, event: event)
      create(:pricing_tier, event: event)

      get :index, event_id: event.id
      json = JSON.parse(response.body)
      data = json['data']

      expect(data.count).to eq event.pricing_tiers.count
    end

    it 'requires the event id to be specified' do
      event = create(:event, user: user)

      get :index
      expect(response.status).to eq 400
    end
  end

  context 'show' do
    it 'returns details about a pricing_tier' do
      event = create(:event, user: user)
      pricing_tier = create(:pricing_tier, event: event)
      create(:pricing_tier, event: event)

      get :show, id: pricing_tier.id
      json = JSON.parse(response.body)
      data = json['data']

      expect(data['attributes']['increase-by-dollars']).to eq pricing_tier.increase_by_dollars.to_s

    end
  end

  context 'update' do
    it 'updates a pricing_tier' do
      event = create(:event, user: user)
      pricing_tier = create(:pricing_tier, event: event)

      json_api = {
        id: pricing_tier.id,
        "data":{
          "id":"#{pricing_tier.id}",
          "attributes":{
            "number_of_leads":28,
            "number_of_follows":26,
            "increase_by_dollars": 321,
            "requirement":1
          },
          "type":"pricing_tiers"}}

      patch :update, json_api

      result = PricingTier.find(pricing_tier.id).increase_by_dollars
      expect(result).to eq 321
    end

    it 'does not updates a pricing_tier when access is denied' do
      event = create(:event, user: create(:user))
      pricing_tier = create(:pricing_tier, event: event)

      json_api = {id: pricing_tier.id, "data":{"id":"#{pricing_tier.id}","attributes":{"number_of_leads":28,"number_of_follows":26,"increase_by_dollars": 123,"requirement":1},"type":"pricing_tiers"}}

      patch :update, json_api

      result = PricingTier.find(pricing_tier.id).increase_by_dollars
      expect(result).to eq pricing_tier.increase_by_dollars
    end
  end

  context 'create' do
    it 'creates a pricing_tier' do
      event = create(:event, user: user)
      force_login(event.hosted_by)
      pricing_tier = build(:pricing_tier, event: event)

      json_api = {"data":{"attributes": pricing_tier.attributes ,"type":"pricing_tiers",
        "relationships": {"event":{"data": {"id": pricing_tier.event_id}}}}}

      expect{
        post :create, json_api
      }.to change(PricingTier, :count).by(1)
    end

    it 'does not create a pricing_tier on someone elses event' do
      event = create(:event, user: create(:user))
      pricing_tier = build(:pricing_tier, event: event)

      json_api = {"data":{"attributes": pricing_tier.attributes ,"type":"pricing_tiers",
        "relationships": {"event":{"data": {"id": pricing_tier.event_id}}}}}

      expect{
        post :create, json_api
      }.to change(PricingTier, :count).by(0)
    end
  end
end
