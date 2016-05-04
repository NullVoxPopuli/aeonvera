require 'rails_helper'

describe Api::UsersController, type: :controller do
  before(:each) do
    ActiveModel::Serializer.config.adapter = ActiveModel::Serializer::Adapter::JsonApi
  end

  context 'show' do
    it 'returns the current user' do
      force_login(user = create(:user))
      get :show, id: -1
      json = response.body

      expected = ActiveModel::SerializableResource.new(user).serializable_hash.to_json
      expect(json).to eq expected
    end

    it 'returns nothing when not logged in' do
      get :show, id: 0 # id doesn't matter
      json = JSON.parse(response.body)
      expect(json['errors']).to be_present
    end
  end

  context 'update' do
    let (:user){ create(:user) }
    it 'updates a user' do
      force_login(user)

      first = user.first_name + ' updated'
      patch :update,  { id: 'current-user', data: { attributes: { first_name: first, current_password: user.password } } }
      json = JSON.parse(response.body)
      first_name_field = json['data']['attributes']['first-name']

      expect(first_name_field).to eq first
    end

    it 'user is not logged in' do
      first = user.first_name + ' updated'
      patch :update,  { id: user.id, data: { attributes: { first_name: first, current_password: user.password } } }
      json = JSON.parse(response.body)

      expect(json['errors']).to be_present
    end

    it 'does not update if no password provided' do
      force_login(user)

      expect{
        patch :update,  { id: user.id, data: { attributes: { password: 'wutwutwut', password_confirmation: 'wutwutwut' } } }
      }.to_not change(User.find(user.id), :encrypted_password)
    end

    it 'ignores the id when a different id is passed' do
      force_login(user)

      first = user.first_name + ' updated'
      patch :update,  { id: user.id + 1, data: { attributes: { first_name: first, current_password: user.password } } }
      json = JSON.parse(response.body)
      first_name_field = json['data']['attributes']['first-name']

      expect(first_name_field).to eq first
    end

    it 'updates password' do
      force_login(user)
      old_password = user.encrypted_password

      patch :update,  { id: user.id, data: { attributes: { password: 'wutwutwut', password_confirmation: 'wutwutwut', current_password: user.password } } }

      new_password = user.reload.encrypted_password

      expect(new_password).to_not eq old_password
    end
  end

  context 'destroy' do
    let (:user){ create(:user) }
    it 'deletes a user' do
      force_login(user)
      expect{
        delete :destroy, id: user.id
      }.to change(User, :count).by(-1)
    end

    it 'does not allow deletion when about to attend an event' do
      force_login(user)
      # data doesn't matter here
      allow(user).to receive(:upcoming_events){ [1] }

      expect{
        delete :destroy, id: user.id
      }.to change(User, :count).by(0)
    end
  end

end
