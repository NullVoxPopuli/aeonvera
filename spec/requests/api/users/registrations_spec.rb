require 'rails_helper'

describe Api::Users::RegistrationsController, type: :request do
  let(:user) { create(:user) }

  before(:each) do
    @headers = {
      'devise.mapping' => Devise.mappings[:api_user]
    }

    host! APPLICATION_CONFIG[:domain][Rails.env]
  end

  context 'update' do
    let(:user) { create(:user, confirmed_at: Time.now) }

    before(:each) do
      @headers.merge!('Authorization' => "Bearer #{user.authentication_token}")
    end

    it 'updates the name' do
      put '/api/users/registrations', { data: { attributes: {
        first_name: user.name + 'updated',
        current_password: user.password } } }, @headers

      expect(response.status).to eq 200

      expect(User.find(user.id).first_name).to eq user.name + 'updated'
    end
  end
end
