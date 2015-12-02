require 'rails_helper'

describe Api::UsersController, type: :request do
  let(:current_user){create(:user)}

  context 'show (this is also the login route)' do
    it 'returns the current user' do
      get "/api/users/0.json?token=#{current_user.authentication_token}&email=#{current_user.email}"
      json = JSON.parse(response.body)

      expect(json['id']).to eq current_user.id
    end
  end

  context 'create' do

  end

  context 'update' do

  end

  context 'destroy' do

  end
end