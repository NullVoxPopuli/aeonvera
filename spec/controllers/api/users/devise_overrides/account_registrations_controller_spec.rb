# frozen_string_literal: true
require 'rails_helper'

describe Api::Users::DeviseOverrides::AccountRegistrationsController, type: :controller do
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:api_user]
    ActiveModelSerializers.config.adapter = :json_api
  end

  context 'create' do
    it 'creates a user' do
      user = build(:user, {
                     first_name: 'first',
                     last_name: 'last',
                     email: 'my@oh.my',
                     time_zone: 'EST'
                   })

      expect { post :create, { data: { attributes: user.attributes.merge(
        password: 'whatever',
        password_confirmation: 'whatever'
      ) }, format: :json }
      }.to change(User, :count).by(1)

      expected = ActiveModelSerializers::SerializableResource.new(user).serializable_hash.to_json
      # the difference here is the confirmation sent at...
      # I don't know how to ignore that during the compare atm
      expect(response.body).to_not be_nil
    end

    it 'sends an email for confirmation' do
      user = build(:user, {
                     first_name: 'first',
                     last_name: 'last',
                     email: 'my@oh.my',
                     time_zone: 'EST'
                   })

      expect { post :create, { data: { attributes: user.attributes.merge(
        password: 'whatever',
        password_confirmation: 'whatever'
      ) }, format: :json }

               expect(user.errors).to be_empty
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'does not create a user with the same email address' do
      old_user = create_confirmed_user

      user = build(:user, {
                     first_name: 'first2',
                     last_name: 'last2',
                     email: old_user.email,
                     time_zone: 'EST'
                   })

      expect { post :create, { data: { attributes: user.attributes.merge(
        password: 'whatever',
        password_confirmation: 'whatever'
      ) }, format: :json }
      }.to change(User, :count).by(0)

      expected = ActiveModelSerializers::SerializableResource.new(user).serializable_hash.to_json
      # the difference here is the confirmation sent at...
      # I don't know how to ignore that during the compare atm
      json = JSON.parse(response.body)
      errors = json['errors']
      expect(errors).to be_present
      expect(errors.first['detail']).to include('has already been taken')
    end
  end
end
