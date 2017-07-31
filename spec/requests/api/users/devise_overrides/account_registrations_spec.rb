# frozen_string_literal: true
require 'rails_helper'

describe Api::Users::DeviseOverrides::AccountRegistrationsController, type: :request do
  let(:user) { create(:user) }

  before(:each) do
    @headers = {
      'devise.mapping' => Devise.mappings[:api_user]
    }

    host! APPLICATION_CONFIG[:domain][Rails.env]
  end

  context 'create' do
    context 'with a valid payload' do
      let(:params) { {
        data: {
          attributes: {
            first_name: 'First',
            last_name: 'Last',
            email: 'emailyMcEmailFace@email.email',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      } }

      it 'returns a valid jsonapi document' do
        post '/api/users', params

        expect { JSONAPI.parse_response!(json_response) }
          .to_not raise_error
      end

      it 'confirms that the confirmation email was sent' do
        post '/api/users', params

        expect(json_response).to have_attribute('confirmation-sent-at')
      end

      it 'creates an account' do
        expect {
          post '/api/users', params
          expect(response.status).to eq 200
        }.to change(User, :count).by 1
      end
    end

    it 'has case-insensitive email addresses' do
      old_user = create(:user)

      # ensure we are actually testing a different casing
      expect(old_user.email.downcase).to eq old_user.email

      expect {
        post '/api/users', {
          data: {
            attributes: {
              first_name: 'First',
              last_name: 'Last',
              email: old_user.email.upcase,
              password: 'password',
              password_confirmation: 'password'
            }
          }
        }
        expect(response.status).to eq 422
      }.to change(User, :count).by 0

      json = JSON.parse(response.body)
      reason = json['errors'].first['detail']
      expect(reason).to eq 'has already been taken'
    end
  end

  context 'update' do
    let(:user) { create(:user, confirmed_at: Time.now) }

    before(:each) do
      @headers.merge!('Authorization' => "Bearer #{user.authentication_token}")
    end

    it 'updates the name' do
      put '/api/users/registrations', { data: { attributes: {
        first_name: user.name + 'updated',
        current_password: user.password
      } } }, @headers

      expect(response.status).to eq 200

      expect(User.find(user.id).first_name).to eq user.name + 'updated'
    end
  end
end
