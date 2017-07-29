# frozen_string_literal: true
require 'rails_helper'

describe Api::HousingRequestsController, type: :request do
  before(:each) do
    host! APPLICATION_CONFIG[:domain][Rails.env]
  end

  context 'logged in' do
    context 'and is registering' do
      let!(:user) { create_confirmed_user }
      let!(:event) { create(:event) }
      let!(:registration) { create(:registration, host: event, attendee: user) }
      let(:payload) {
        {
          'data' => {
            'attributes' => {
              'need-transportation' => true, 'can-provide-transportation' => true, 'transportation-capacity' => 7,
              'allergic-to-pets' => false, 'allergic-to-smoke' => true, 'other-allergies' => 'aoeuaoeu',
              'preferred-gender-to-house-with' => 'No Preference', 'notes' => 'oeu', 'name' => nil,
              'requested-roommates' => ['a', nil, nil, nil],
              'unwanted-roommates' => [nil, nil, nil, nil]
            },
            'relationships' => {
              'host' => { 'data' => { 'type' => 'events', 'id' => event.id } },
              'registration' => { 'data' => { 'type' => 'registrations', 'id' => registration.id } },
              'housing-provision' => { 'data' => nil }
            },
            'type' => 'housing-requests'
          }
        }
      }

      before(:each) do
        auth_header_for(user)
      end

      context 'create' do
        subject { post '/api/housing_requests', payload, @headers }

        it { is_expected.to eq 201 }

        it 'creates a housing request' do
          expect { subject }.to change(HousingRequest, :count).by 1
        end
      end

      context 'show' do
        let!(:housing_request) { create(:housing_request, registration: registration) }

        subject { get "/api/housing_requests/#{housing_request.id}", payload, @headers }

        it { is_expected.to eq 200 }
      end

      context 'update' do
        let!(:housing_request) { create(:housing_request, registration: registration) }
        let(:update_params) {
          {
            data: {
              attributes: {},
              relationships: {},
              type: 'housing-requests'
            }
          }
        }

        subject { patch "/api/housing_requests/#{housing_request.id}", update_params, @headers }

        it { is_expected.to eq 200 }
      end

      context 'delete' do
        let!(:housing_request) { create(:housing_request, registration: registration) }

        subject { delete "/api/housing_requests/#{housing_request.id}", {}, @headers }

        it { is_expected.to eq 200 }
      end
    end

    context 'owns the event' do
      before(:each) do
        user = create_confirmed_user
        auth_header_for(user)
        @event = create(:event, hosted_by: user)
        @registration = create(:registration, host: @event)
        @housing_request = create(:housing_request, host: @event)
        create(:housing_request, host: @event)
      end

      it 'can read all' do
        get "/api/housing_requests?event_id=#{@event.id}", {}, @headers
        expect(response.status).to eq 200
      end

      it 'can delete' do
        expect {
          delete "/api/housing_requests/#{@housing_request.id}?event_id=#{@event.id}", {}, @headers
        }.to change(HousingRequest.with_deleted, :count).by 0
        expect(response.status).to eq 200
      end

      context 'creating' do
        let(:payload) do
          {
            'data' => {
              'attributes' => {},
              'relationships' => { 'host' => { 'data' => { 'type' => 'events', 'id' => @event.id } }, 'registration' => { 'data' => { 'type' => 'event-registrations', 'id' => @registration.id } } },
              'type' => 'housing-requests'
            }
          }
        end

        it 'creates' do
          expect {
            post '/api/housing_requests', payload, @headers
            expect(response.status).to eq 201
          }.to change(HousingRequest, :count).by 1
        end

        it 'is tied to the registration' do
          post '/api/housing_requests', payload, @headers
          id = json_api_data['id']
          expect(HousingRequest.find(id).registration).to eq @registration
        end
      end
    end
  end
end
