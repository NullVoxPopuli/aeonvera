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
end
