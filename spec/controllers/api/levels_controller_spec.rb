require 'rails_helper'

describe Api::LevelsController, type: :controller do
  context 'index' do

    it 'gets all levels' do
      event = create_event
      create(:level, event: event)
      create(:level, event: event)

      get :index
      json = JSON.parse(response.body)
      data = json['data']

      expect(data.count).to eq 2
    end
  end

  context 'show' do
    it 'returns details about a level' do
      event = create_event
      level = create(:level, event: event)
      create(:level, event: event)

      get :show, id: level.id
      json = JSON.parse(response.body)
      data = json['data']

      expect(data['attributes']['name']).to eq level.name

    end
  end

  context 'update' do
    it 'updates a level' do
      force_login(user = create(:user))
      event = create(:event, user: user)
      level = create(:level, event: event)

      new_name = level.name + ' updated'
      json_api = {id: level.id, "data":{"id":"#{level.id}","attributes":{"number_of_leads":28,"number_of_follows":26,"name": new_name,"requirement":1},"type":"levels"}}

      patch :update, json_api

      expect(Level.find(level.id).name).to eq new_name
    end

    it 'does not updates a level when access is denied' do
      force_login(user = create(:user))
      event = create(:event, user: create(:user))
      level = create(:level, event: event)

      new_name = level.name + ' updated'
      json_api = {id: level.id, "data":{"id":"#{level.id}","attributes":{"number_of_leads":28,"number_of_follows":26,"name": new_name,"requirement":1},"type":"levels"}}

      patch :update, json_api

      expect(Level.find(level.id).name).to eq level.name
    end
  end

  context 'create' do
    it 'creates a level' do
      force_login(user = create(:user))
      event = create(:event, user: user)
      force_login(event.hosted_by)
      level = build(:level, event: event)

      json_api = {"data":{"attributes": level.attributes ,"type":"levels",
        "relationships": {"event":{"data": {"id": level.event_id}}}}}

      expect{
        post :create, json_api
      }.to change(Level, :count).by(1)
    end

    it 'does not create a level on someone elses event' do
      force_login(user = create(:user))
      event = create(:event, user: create(:user))
      level = build(:level, event: event)

      json_api = {"data":{"attributes": level.attributes ,"type":"levels",
        "relationships": {"event":{"data": {"id": level.event_id}}}}}
        
      expect{
        post :create, json_api
      }.to change(Level, :count).by(0)
    end
  end
end
