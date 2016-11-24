require 'rails_helper'

describe Api::RestraintsController, type: :request do
  before(:each) do
    host! APPLICATION_CONFIG[:domain][Rails.env]
  end

  let(:organization) { create(:organization, owner: create_confirmed_user) }
  let(:owner) { organization.hosted_by }
  let(:stray_user) { create_confirmed_user }
  let(:collaborator) { create_confirmed_user }
  let(:host_params) { "host_id=#{organization.id}&host_type=Organization" }
  let(:set_login_header_as) do
    lambda do |user|
      @headers = { 'Authorization' => 'Bearer ' + user.authentication_token }
    end
  end

  context 'is not logged in' do
    it 'cannot create' do
      post '/api/restraints', {}
      expect(response.status).to eq 401
    end

    context 'data exists' do
      let(:restraint) { create(:restraint) }

      it 'cannot index' do
        get '/api/restraints'
        expect(response.status).to eq 401
      end

      it 'cannot update' do
        put "/api/restraints/#{restraint.id}"
        expect(response.status).to eq 401
      end

      it 'cannot destroy' do
        delete "/api/restraints/#{restraint.id}"
        expect(response.status).to eq 401
      end
    end
  end

  context 'is logged in' do

    context 'is owner' do
      before(:each) do
        set_login_header_as.call(owner)
      end

      context 'creating' do
        xit 'can create' do
          create_params = {}
          post '/api/restraints', create_params, @headers
          expect(response.status).to eq 200
        end
      end
    end

    context 'is collaborator' do
      before(:each) do
        set_login_header_as.call(collaborator)
      end
    end

    context 'is non collaborator' do
      before(:each) do
        set_login_header_as.call(stray_user)
      end
    end
  end
end
