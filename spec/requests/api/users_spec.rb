# frozen_string_literal: true
require 'rails_helper'

describe Api::UsersController, type: :request do
  include RequestSpecUserSetup

  context 'show (this is also the login route)' do
    it 'returns the current user' do
      get '/api/users/0', {}, auth_header_for(user)

      expect(json_api_data['id']).to eq 'current-user'
      expect(json_api_data['attributes']['email']).to eq user.email
    end
  end

  context 'create' do
  end

  context 'update' do
  end

  context 'destroy' do
    it 'requires login' do
      user = create(:user)

      expect {
        delete "/api/users/#{user.id}", {}
        expect(response.status).to eq 401
      }.to change(User, :count).by(0)
    end

    it 'requires the password' do
      user = create(:user)

      expect {
        delete "/api/users/#{user.id}", {}, auth_header_for(user)
        expect(response.status).to eq 422
      }.to change(User, :count).by(0)
    end

    it 'is prevented when the user is attending an event' do
      create(:registration, attendee: user)
      params = {
        password: user.password
      }

      expect {
        delete "/api/users/#{user.id}", params, auth_header_for(user)
        expect(response.status).to eq 422
      }.to change(User, :count).by(0)
    end

    it 'deletes the user' do
      params = {
        password: user.password
      }

      expect {
        delete "/api/users/#{user.id}", params, auth_header_for(user)
        expect(response.status).to eq 200
      }.to change(User, :count).by(-1)
    end
  end
end
