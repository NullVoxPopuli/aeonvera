require 'rails_helper'


describe Api::Users::ConfirmationsController, type: :request do
  let(:user) { create(:user) }

  before(:each) do
    @headers = {
      "devise.mapping" => Devise.mappings[:api_user]
    }

    host! APPLICATION_CONFIG[:domain][Rails.env]
  end

  context 'confirms the email address' do
    it 'clears the confirmation token' do
      skip('why is this going to the users controller?')
      get '/api/users/confirmations?confirmation_token=' + user.confirmation_token, {}, @headers

      user.reload
      expect(user.confirmation_token).to be_nil
    end

    it 'sets confirmed at' do
      skip('why is this going to the users controller?')
      get '/api/confirmations?confirmation_token=' + user.confirmation_token

      user.reload
      expect(user.confirmed_at).to_not be_nil
    end
  end

  context 'requests a new confirmation token' do
    it 'sends an email' do
      # force the let(:user) to be invoked
      expect(user.confirmation_sent_at).to_not be_nil
      expect {
        post '/api/users/confirmation', user: { email: user.email }
      }.to change(ActionMailer::Base.deliveries, :count).by 1
    end

    it 'changes the confirmation token' do
      old_token = user.confirmation_token
      post '/api/users/confirmation', user: { email: user.email }
      user.reload
      expect(user.confirmation_token).to_not eq old_token
    end
  end
end
