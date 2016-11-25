# frozen_string_literal: true
require 'rails_helper'

describe Api::IntegrationsController, type: :request do
  include RequestSpecUserSetup

  let(:create_params) {
    jsonapi_params(
      'integrations',
      attributes: {
        kind: 'stripe',
        authorizationCode: 'fake-auth-code'
      },
      relationships: { owner: event }
    )
  }

  let(:create_for_organization_params) {
    jsonapi_params(
      'integrations',
      attributes: {
        kind: 'stripe',
        authorizationCode: 'fake-auth-code'
      },
      relationships: { owner: organization }
    )
  }

  context 'is not logged in' do
    it 'connot create' do
      post '/api/integrations', create_params
      expect(response.status).to eq 401
    end
  end

  context 'is logged in' do
    context 'owns the event' do
      it 'creates' do
        expect {
          post '/api/integrations', create_params, auth_header_for(owner)
          expect(response.status).to eq 201
        }.to change(Integration, :count).by(1)
      end
    end

    context 'owns the organization' do
      it 'creates' do
        expect {
          post '/api/integrations', create_for_organization_params, auth_header_for(owner)
          expect(response.status).to eq 201
        }.to change(Integration, :count).by(1)
      end
    end

    context 'collaborates on the event' do
      it 'does not create' do
        expect {
          post '/api/integrations', create_params, auth_header_for(event_collaborator)
          expect(response.status).to eq 404
        }.to change(Integration, :count).by(0)
      end
    end

    context 'does not collaborate' do
      it 'does not create' do
        expect {
          post '/api/integrations', create_params, auth_header_for(stray_user)
          expect(response.status).to eq 404
        }.to change(Integration, :count).by(0)
      end
    end
  end
end
