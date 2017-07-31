# frozen_string_literal: true
require 'rails_helper'

describe Api::HousingProvisionsController, type: :request do
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
            'attributes' => {},
            'relationships' => {
              'host' => { 'data' => { 'type' => 'events', 'id' => event.id } },
              'registration' => { 'data' => { 'type' => 'registrations', 'id' => registration.id } },
              'housing-provision' => { 'data' => nil }
            },
            'type' => 'housing-provisions'
          }
        }
      }

      before(:each) do
        auth_header_for(user)
      end

      context 'create' do
        subject { post '/api/housing_provisions', payload, @headers }

        it { is_expected.to eq 201 }

        it 'creates a housing provision' do
          expect { subject }.to change(HousingProvision, :count).by 1
        end
      end

      context 'show' do
        let!(:housing_provision) { create(:housing_provision, registration: registration) }

        subject { get "/api/housing_provisions/#{housing_provision.id}", payload, @headers }

        it { is_expected.to eq 200 }
      end

      context 'update' do
        let!(:housing_provision) { create(:housing_provision, registration: registration) }
        let(:update_params) {
          {
            data: {
              attributes: {},
              relationships: {},
              type: 'housing-provisions'
            }
          }
        }

        subject { patch "/api/housing_provisions/#{housing_provision.id}", update_params, @headers }

        it { is_expected.to eq 200 }
      end

      context 'delete' do
        let!(:housing_provision) { create(:housing_provision, registration: registration) }

        subject { delete "/api/housing_provisions/#{housing_provision.id}", {}, @headers }

        it { is_expected.to eq 200 }
      end
    end

    context 'owns the event' do
      before(:each) do
        user = create_confirmed_user
        auth_header_for(user)
        @event = create(:event, hosted_by: user)
        @registration = create(:registration, host: @event)
        @housing_provision = create(:housing_provision, host: @event, registration: @registration)
        create(:housing_provision, host: @event, registration: @registration)
      end

      it 'can read all' do
        get "/api/housing_provisions.csv?event_id=#{@event.id}", {}, @headers
        expect(response.status).to eq 200
      end

      it 'selects attributes' do
        get "/api/housing_provisions.csv?event_id=#{@event.id}&fields=housingCapacity,numberOfShowers,registration.attendeeName", {}, @headers
        expect(response.status).to eq 200
      end

      it 'can delete' do
        expect {
          delete "/api/housing_provisions/#{@housing_provision.id}?event_id=#{@event.id}", {}, @headers
        }.to change(HousingProvision.with_deleted, :count).by 0
        expect(response.status).to eq 200
      end

      context 'creating' do
        let(:payload) do
          {
            'data' => {
              'attributes' => { 'housing-capacity' => 0, 'number-of-showers' => 0, 'can-provide-transportation' => false, 'transportation-capacity' => 0, 'preferred-gender-to-host' => 'No Preference', 'has-pets' => false, 'smokes' => false, 'notes' => nil, 'name' => nil },
              'relationships' => { 'host' => { 'data' => { 'type' => 'events', 'id' => @event.id } }, 'registration' => { 'data' => { 'type' => 'registrations', 'id' => @registration.id } } },
              'type' => 'housing-provisions'
            }
          }
        end

        it 'creates' do
          expect {
            post '/api/housing_provisions', payload, @headers
            expect(response.status).to eq 201
          }.to change(HousingProvision, :count).by 1
        end

        it 'is tied to the registration' do
          post '/api/housing_provisions', payload, @headers
          id = json_api_data['id']
          expect(HousingProvision.find(id).registration).to eq @registration
        end
      end
    end
  end
end
