# frozen_string_literal: true
require 'spec_helper'

describe 'AMS monkey patches' do
  describe 'nested field whitelisting on attributes' do
    it 'shows relationship fields' do
      user = build(:user)
      event = build(:event)
      attendance = build(:attendance, attendee: user, host: event)
      housing_provision = build(:housing_provision, attendance: attendance, host: event)

      # fields = { housing_provisions: [ :id, :housing_capacity, { attendance: [ :attendee_name ] } ] }
      fields = [:id, :housing_capacity, { attendance: [:attendee_name] }]
      options = {
        adapter: :attributes,
        key_transform: :underscore,
        fields: fields
      }
      result = ActiveModelSerializers::SerializableResource.new(housing_provision, options).serializable_hash

      expected = {
        id: nil,
        housing_capacity: 10,
        attendance: {
          attendee_name: "Æonvera User Test"
        }

      }

      expect(result).to eq expected
    end

    it 'shows relationship fields for multiple objects' do
      user = build(:user)
      event = build(:event)
      attendance = build(:attendance, attendee: user, host: event)
      housing_provision = build(:housing_provision, attendance: attendance, host: event)

      # fields = { housing_provisions: [ :id, :housing_capacity, { attendance: [ :attendee_name ] } ] }
      fields = [:id, :housing_capacity, { attendance: [:attendee_name] }]
      options = {
        adapter: :attributes,
        key_transform: :underscore,
        fields: fields
      }
      result = ActiveModelSerializers::SerializableResource.new([housing_provision, housing_provision], options).serializable_hash

      expected = [{
        id: nil,
        housing_capacity: 10,
        attendance: {
          attendee_name: "Æonvera User Test"
        }
      },
      {
        id: nil,
        housing_capacity: 10,
        attendance: {
          attendee_name: "Æonvera User Test"
        }
      }]

      expect(result).to eq expected
    end
  end
end
