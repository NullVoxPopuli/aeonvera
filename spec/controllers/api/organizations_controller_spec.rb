# frozen_string_literal: true

require 'rails_helper'

describe Api::OrganizationsController do
  context 'index' do
    it 'returns all of the organizations' do
      create(:organization)
      create(:organization)
      create(:organization)

      get :index
      json = JSON.parse(response.body)
      expect(json['data'].count).to eq Organization.all.count
    end
  end
end
