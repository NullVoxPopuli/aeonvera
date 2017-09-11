# frozen_string_literal: true

describe CsvGeneration do
  let(:housing_request) { create(:housing_request, registration: create(:registration)) }
  let(:resource_class) { ::Api::HousingRequestSerializableResource }

  before(:each) { pending('CSVs are hard'); fail }

  describe '.serialize_data' do
    let(:options) do
      { class: resource_class }
    end

    subject { ->(*args) { described_class.serialize_data(*args) } }

    it 'renders only the default fields' do
      result = subject.call(options, [housing_request])

      expect(result).to eq [
        {
          notes: housing_request.notes,
          name: housing_request.name,
          need_transportation: housing_request.need_transportation,
          can_provide_transportation: housing_request.can_provide_transportation,
          transportation_capacity: housing_request.transportation_capacity,
          allergic_to_pets: housing_request.allergic_to_pets,
          allergic_to_smoke: housing_request.allergic_to_smoke,
          other_allergies: housing_request.other_allergies,
          requested_roommates: housing_request.requested_roommates,
          unwanted_roommates: housing_request.unwanted_roommates,
          preferred_gender_to_house_with: housing_request.preferred_gender_to_house_with,
          housing_provision_id: housing_request.housing_provision_id
        }
      ]
    end

    it 'renders specific fields' do
      options[:fields] = { 'housing-requests': [:transportation_capacity] }
      result = subject.call(options, [housing_request])

      expect(result).to eq [
        {
          transportation_capacity: housing_request.transportation_capacity
        }
      ]
    end

    it 'renders fields on a relationship' do
      options = described_class.options_from_fields('registration.attendee_name', resource_class).merge(class: resource_class)
      result = subject.call(options, [housing_request])

      expect(result).to eq [
        {
          attendee_name: housing_request.registration.attendee_name
        }
      ]
    end

    it 'includes a mix of fields and relational fields' do
      options = described_class.options_from_fields('transportation_capacity,registration.attendee_name', resource_class).merge(class: resource_class)
      result = subject.call(options, [housing_request])

      expect(result).to eq [
        {
          attendee_name: housing_request.registration.attendee_name,
          transportation_capacity: housing_request.transportation_capacity
        }
      ]
    end
  end

  describe '.options_from_fields' do
    subject { ->(*args) { described_class.options_from_fields(*args) } }

    it 'sets included' do
      result = subject.call('relationship.attendee_name,other.email', resource_class)

      expect(result).to eq({
                             fields: {
                               'housing-requests': [:relationship, :other],
                               relationships: [:attendee_name],
                               others: [:email] },
                             include: 'relationship,other'
                           })
    end
  end

  describe '.merge_attributes_with_data' do
    subject { ->(*args) { described_class.merge_attributes_with_data(*args) } }

    it 'has no attributes, a relationship, and nothing included' do
      result = subject.call(
        nil, {
          registration: {
            data: {
              type: :'users/registrations',
              id: housing_request.registration.id
            }
          }
        },
        nil,
        { class: resource_class }
      )

      expect(result).to eq({})
    end

    it 'has no attributes, a relationship, and included' do
      result = subject.call(
        nil, {
          registration: {
            data: {
              type: :'users/registrations',
              id: housing_request.registration.id
            }
          }
        },
        {
          'users/registrations': {
            housing_request.registration.id => {
              attendee_name: 'name'
            }
          }
        },
        { class: resource_class, fields: { registrations: [:attendee_name] } }
      )

      expect(result).to eq({ attendee_name: 'name' })
    end
  end
end
