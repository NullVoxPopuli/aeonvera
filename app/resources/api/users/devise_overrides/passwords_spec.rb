# frozen_string_literal: true

require 'rails_helper'

describe Api::Users::DeviseOverrides::PasswordsController, type: :request do
  let(:user) { create(:user, confirmed_at: Time.now) }

  context 'requests a password reset' do
    it 'sends an email' do
      expect {
        post '/api/users/password', user: { email: user.email }
      }.to change(ActionMailer::Base.deliveries, :count).by 1
    end

    it 'sets the password reset token' do
      expect(user.reset_password_token).to be_nil
      post '/api/users/password', user: { email: user.email }
      user.reload
      expect(user.reset_password_token).to_not be_nil
    end

    it 'trys an email that is not found' do
      post '/api/users/password', user: { email: "#{user.email}---#{user.email}" }

      expect(response.status).to eq 422
      actual = json_response['errors'].map { |e| e['detail'] }.join
      expect(actual).to match(/not found/)
    end

    it 'asks for a password reset token twice.' do
      post '/api/users/password', user: { email: user.email }
      post '/api/users/password', user: { email: user.email }

      expect(response.status).to eq 200
    end
  end

  context 'resets the password' do
    before(:each) do
      user.reset_password_token = '123'
      user.reset_password_sent_at = Time.now
      user.save
    end

    it 'returns an error when no data is submitted' do
      put '/api/users/password', user: {}

      expect(response.status).to eq 422

      actual = json_response['errors'].map { |e| e['detail'] }.join
      expect(actual).to match(/can't be blank/)
    end

    it 'returns an error when the passwords do not match' do
      put '/api/users/password', user: {
        password: '1234',
        password_confirmation: '12345678',
        reset_password_token: '123'
      }

      actual = json_response['errors'].map { |e| e['detail'] }.join
      expect(actual).to match(/match Password/)
      expect(actual).to match(/too short/)
    end

    it 'returns an error when the token does not match' do
      put '/api/users/password', user: {
        password: '12345678',
        password_confirmation: '12345678',
        reset_password_token: '123453'
      }

      actual = json_response['errors'].map { |e| e['detail'] }.join
      expect(actual).to match(/is invalid/)
    end

    it 'returns an error when the token has already been used' do
      set_password = -> {
        put '/api/users/password', user: {
          password: '12345678',
          password_confirmation: '12345678',
          reset_password_token: '123'
        }
      }

      set_password.call
      set_password.call

      expect(response.status).to eq 422
      actual = json_response['errors'].map { |e| e['detail'] }.join
      expect(actual).to match(/is invalid/)
    end

    it 'changes the password' do
      old_password = user.encrypted_password
      put '/api/users/password', user: {
        password: '12345678',
        password_confirmation: '12345678',
        reset_password_token: '123'
      }

      user.reload
      expect(user.encrypted_password).to_not eq old_password
    end

    it 'clears the password reset token' do
      put '/api/users/password', user: {
        password: '12345678',
        password_confirmation: '12345678',
        reset_password_token: '123'
      }

      user.reload
      expect(user.reset_password_token).to be_nil
      expect(user.reset_password_sent_at).to be_nil
    end
  end
end
