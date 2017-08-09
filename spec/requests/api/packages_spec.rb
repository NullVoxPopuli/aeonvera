# frozen_string_literal: true

require 'rails_helper'

describe Api::PackagesController, type: :request do
  include RequestSpecUserSetup

  context 'is not logged in' do
  end

  context 'is logged in' do
    let(:create_params) do
      jsonapi_params(
        'packages',
        attributes: {
          name: 'some_package',
          initial_price: 10,
          at_the_door_price: 10
        },
        relationships: {
          event: event
        }
      )
    end

    context 'owns the event' do
      before(:each) { auth_header_for(owner) }

      it 'creates' do
        expect do
          post '/api/packages', create_params, @headers
          expect(response.status).to eq 201
        end.to change(Package, :count).by(1)
      end
    end

    context 'collaborates on the event' do
      before(:each) { auth_header_for(event_collaborator) }

      it 'creates' do
        expect do
          post '/api/packages', create_params, @headers
          expect(response.status).to eq 201
        end.to change(Package, :count).by(1)
      end
    end

    context 'is not a collaborator' do
      before(:each) { auth_header_for(stray_user) }

      it 'does not create' do
        expect do
          post '/api/packages', create_params, @headers
          expect(response.status).to eq 404
        end.to change(Package, :count).by(0)
      end
    end
  end
end
