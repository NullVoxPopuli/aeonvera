require 'rails_helper'

describe Api::HostsController, type: :controller do

  context 'index' do
    it 'wraps the host in a collection' do
      event = create_event
      get :index, subdomain: event.subdomain
      json = JSON.parse(response.body)
      data = json['data']

      expect(data.count).to eq 1
      expect(data.first['attributes']['domain']).to include(event.subdomain)
    end
  end

  context 'show' do
    it 'returns the host for the subdomain' do
      event = create_event
      get :show, id: 0, subdomain: event.subdomain
      json = JSON.parse(response.body)
      data = json['data']

      expect(data['attributes']['domain']).to include(event.subdomain)
    end

    it 'returns on org' do
      organization = create(:organization)
      get :show, id: 0, subdomain: organization.subdomain
      json = JSON.parse(response.body)
      data = json['data']

      expect(data['attributes']['domain']).to include(organization.subdomain)
    end
  end
end
