# frozen_string_literal: true
require 'rails_helper'

describe Api::HostedEventsController, type: :controller do
  context 'index' do
    it 'shows a users hosted events' do
      event = create_event
      force_login(event.hosted_by)

      get :index
      json = JSON.parse(response.body)
      expect(json.count).to eq current_user.hosted_events.count
    end

    it 'shows a users collaborated events' do
      event = create_event
      user = create(:user)
      event.collaborators << user
      event.save

      force_login(user)

      get :index
      json = JSON.parse(response.body)
      expect(json.count).to eq current_user.collaborated_events.count
    end
  end

  context 'show' do
    it 'returns a hosted event' do
      event = create_event
      force_login(event.hosted_by)

      get :show, id: event.id
      json = JSON.parse(response.body)
      expect(json['data']['attributes']['name']).to eq event.name
    end

    it 'returns a collaborated event' do
      skip('need to work out active query for this')
    end
  end
end
