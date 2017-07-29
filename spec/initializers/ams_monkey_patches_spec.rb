# frozen_string_literal: true
require 'spec_helper'

describe 'AMS monkey patches' do
  describe 'nested field whitelisting on attributes' do
    it 'shows relationship fields' do
      user = build(:user)
      event = build(:event)
      registration = build(:registration, attendee: user, host: event)
      housing_provision = build(:housing_provision, registration: registration, host: event)

      fields = [:id, :housing_capacity, { registration: [:attendee_name] }]
      options = {
        adapter: :attributes,
        key_transform: :underscore,
        fields: fields,
        serializer: Api::HousingProvisionSerializer
      }
      resource = ActiveModelSerializers::SerializableResource.new(housing_provision, options)
      result = resource.serializable_hash

      expected = {
        id: nil,
        housing_capacity: 10,
        registration: {
          attendee_name: "æonvera User Test"
        }
      }

      expect(result).to eq expected
    end

    it 'shows relationship fields for multiple objects' do
      user = build(:user)
      event = build(:event)
      registration = build(:registration, attendee: user, host: event)
      housing_provision = build(:housing_provision, registration: registration, host: event)

      # fields = { housing_provisions: [ :id, :housing_capacity, { registration: [ :attendee_name ] } ] }
      fields = [:id, :housing_capacity, { registration: [:attendee_name] }]
      options = {
        adapter: :attributes,
        key_transform: :underscore,
        fields: fields,
        each_serializer: Api::HousingProvisionSerializer
      }
      result = ActiveModelSerializers::SerializableResource.new([housing_provision, housing_provision], options).serializable_hash

      expected = [
        {
          id: nil,
          housing_capacity: 10,
          registration: {
            attendee_name: "æonvera User Test"
          }
        },
        {
          id: nil,
          housing_capacity: 10,
          registration: {
            attendee_name: "æonvera User Test"
          }
        }
      ]

      expect(result).to eq expected
    end
  end
end
