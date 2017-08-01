# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::HousingProvisionsController, type: :controller do
  let(:event) { create(:event) }
  before(:each) do
    login_through_api
    @registration = create(:registration, host: event, attendee: @user)
  end

  context 'create' do
    it 'creates a new housing provision' do
      json_api = {
        data: {
          type: 'housing-provisions',
          attributes: {
            housing_capacity: 4,
            number_of_showers: 2,
            can_provide_transportation: true,
            transportation_capacity: 4,
            preferred_gender_to_host: 'Robots',
            has_pets: true,
            smokes: false,
            notes: 'Lots of couches'
          },
          relationships: {
            registration: {
              data: {
                id: @registration.id,
                type: 'users/registrations'
              }
            },
            host: {
              data: {
                id: event.id,
                type: 'events'
              }
            }
          }
        }
      }

      json_api_create_with(HousingProvision, json_api)
    end
  end

  context 'update' do
    before(:each) do
      @housing_provision = create(
        :housing_provision,
        host: event,
        registration: @registration,
        preferred_gender_to_host: 'Robots'
      )
    end

    it 'updates a housing request' do
      json_api = {
        data: {
          id: @housing_provision.id,
          type: 'housing-provisions',
          attributes: {
            housing_capacity: @housing_provision.housing_capacity + 4,
            number_of_showers: @housing_provision.number_of_showers + 2,
            can_provide_transportation: !@housing_provision.can_provide_transportation,
            transportation_capacity: @housing_provision.transportation_capacity + 4,
            preferred_gender_to_host: 'No Preference',
            has_pets: !@housing_provision.has_pets,
            smokes: !@housing_provision.smokes,
            notes: 'Lots of couches'
          }
        }
      }

      json_api_update_with(@housing_provision, json_api)
    end
  end
end
