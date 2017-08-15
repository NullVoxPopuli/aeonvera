# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::HousingRequestsController, type: :controller do
  let(:user)  { create_confirmed_user }
  let(:event) { create(:event, hosted_by: user) }
  before(:each) do
    login_through_api
  end

  context 'create' do
    it 'creates a new housing request' do
      json_api = {
        data: {
          type: 'housing-requests',
          attributes: {
            need_transportation: true,
            can_provide_transportation: true,
            transportation_capacity: 4,
            allergic_to_pets: true,
            allergic_to_smoke: true,
            other_allergies: 'stuff',
            preferred_gender_to_house_with: 'No Preference',
            notes: 'I like wheat thins',
            requested_roommates: %w(a b c d),
            unwanted_roommates: %w(1 2 3 4)
          },
          relationships: {
            host: {
              data: {
                id: event.id,
                type: 'events'
              }
            }
          }
        }
      }

      json_api_create_with(HousingRequest, json_api)
    end
  end

  context 'update' do
    before(:each) do
      @housing_request = create(
        :housing_request,
        host: event,
        preferred_gender_to_house_with: 'Robots'
      )
    end

    it 'updates a housing request' do
      json_api = {
        data: {
          id: @housing_request.id,
          type: 'housing-requests',
          attributes: {
            need_transportation: !@housing_request.need_transportation,
            can_provide_transportation: !@housing_request.can_provide_transportation,
            transportation_capacity: @housing_request.transportation_capacity + 1,
            allergic_to_pets: !@housing_request.allergic_to_pets,
            allergic_to_smoke: !@housing_request.allergic_to_smoke,
            other_allergies: @housing_request.other_allergies + ' some stuff',
            preferred_gender_to_house_with: 'No Preference',
            notes: 'I like wheat thins',
            requested_roommates: %w(1 2 3 4),
            unwanted_roommates: %w(9 8 7 6)
          }
        }
      }

      json_api_update_with(@housing_request, json_api)
    end
  end
end
