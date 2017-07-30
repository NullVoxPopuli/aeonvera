# frozen_string_literal: true
require 'rails_helper'

describe Api::Users::RegistrationsController, type: :request do
  base_path = '/api/users/registrations'

  context 'not logged in' do
    it_behaves_like(
      'unauthorized',
      factory: :registration,
      base_path: base_path
    )
  end

  context 'logged in' do
    let(:event) { create(:event) }
    let(:user) { create_confirmed_user }

    context 'index' do
      it 'has no registrations' do
        get base_path, {}, auth_header_for(user)

        expect(response.status).to eq 200
        expect(json_api_data.length).to eq 0
      end

      context 'has registrations' do
        before(:each) do
          create(:registration, attendee: user, host: event)
        end

        it 'lists registrations' do
          get base_path, {}, auth_header_for(user)

          expect(json_api_data.length).to eq 1
        end
      end
    end

    context 'show' do
      let(:registration) { create(:registration, attendee: user, host: event) }

      it 'retrieves a registration' do
        get "#{base_path}/#{registration.id}", {}, auth_header_for(user)

        expect(response.status).to eq 200
      end
    end

    context 'create' do
      it 'creates a registration' do
        params = jsonapi_params(
          'registrations',
          attributes: {
            attendee_first_name: 'The',
            attendee_last_name: 'Last',
            dance_orientation: Registration::LEAD
          },
          relationships: { host: event }
        )

        post base_path, params, auth_header_for(user)

        expect(response.status).to eq 200
      end
    end

    context 'update' do
      let(:registration) { create(:registration, attendee_first_name: 'A', attendee: user, host: event) }

      it 'updates a registration' do
        params = jsonapi_params(
          'registrations',
          id: registration.id,
          attributes: { attendee_first_name: 'B' }
        )

        put "#{base_path}/#{registration.id}", params, auth_header_for(user)

        expect(response.status).to eq 200
        expect(json_api_data['attributes']['attendee_first_name']).to eq 'B'
      end
    end

    context 'destroy' do
      let!(:registration) { create(:registration, attendee: user, host: event) }

      it 'deletes a registration' do
        expect { delete "#{base_path}/#{registration.id}" }
          .to change(Registration, :count).by(-1)
      end
    end
  end
end
