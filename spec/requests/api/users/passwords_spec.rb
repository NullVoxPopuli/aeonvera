require 'rails_helper'


describe Api::Users::PasswordsController, type: :request do
  let(:user) { create(:user, confirmed_at: Time.now) }

  context 'requests a password reset' do
    it 'sends an email' do
      expect{
        post '/api/users/password', user: { email: user.email }
      }.to change(ActionMailer::Base.deliveries, :count).by 1
    end

    it 'sets the password reset token' do
      expect(user.reset_password_token).to be_nil
      post '/api/users/password', user: { email: user.email }
      user.reload
      expect(user.reset_password_token).to_not be_nil
    end
  end

  context 'resets the password' do
    before(:each) do
      user.reset_password_token = '123'
      user.reset_password_sent_at = Time.now
      user.save
    end

    it 'changes the password' do
      old_password = user.encrypted_password
      put '/api/users/password', user: {
        password: '12345678',
        password_confirmation: '12345678',
        reset_password_token: '123' }

      user.reload
      expect(user.encrypted_password).to_not eq old_password
    end

    it 'clears the password reset token' do
      put '/api/users/password', user: {
        password: '12345678',
        password_confirmation: '12345678',
        reset_password_token: '123' }

      user.reload
      expect(user.reset_password_token).to be_nil
      expect(user.reset_password_sent_at).to be_nil
    end
  end

end
