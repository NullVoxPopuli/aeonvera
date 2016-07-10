require 'rails_helper'

describe Api::Users::SessionsController, type: :request do
  let(:user) { create(:user) }

  before(:each) do
    @headers = {
      'devise.mapping' => Devise.mappings[:api_user]
    }

    host! APPLICATION_CONFIG[:domain][Rails.env]
  end

  describe 'login' do

    it 'logs in' do
      user = create(:user, confirmed_at: Time.now)
      post '/api/users/sign_in', { email: user.email, password: user.password }
      expect(response.status).to eq 201
    end

    it 'logs in with different casing' do
      user = create(:user, confirmed_at: Time.now)
      post '/api/users/sign_in', { email: user.email.upcase, password: user.password }
      expect(response.status).to eq 201
    end

    it 'has incorrect password' do
      user = create(:user, confirmed_at: Time.now)
      post '/api/users/sign_in', { email: user.email, password: user.password + '1' }
      expect(response.status).to eq 401
    end

    it 'has email not found' do
      post '/api/users/sign_in', { email: 'a@a.a', password: '123' }
      expect(response.status).to eq 401
    end

  end
end
