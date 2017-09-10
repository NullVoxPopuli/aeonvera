# frozen_string_literal: true

describe CsvGeneration do
  describe '.serialize_data' do
    let(:housing_request) { create(:housing_request) }

    subject { ->(*args) { described_class.serialize_data(*args) } }
    before(:each) { pending('csvs are hard') }
    it 'renders only the default fields' do
      result = subject.call([housing_request], nil, serializer: ::Api::HousingRequestSerializableResource)

      expect(result).to eq [
        {

        }
      ]
    end

    it 'renders specific fields' do
      result = subject.call([housing_request], [:transportation_capacity], serializer: ::Api::HousingRequestSerializableResource)

      expect(result).to eq [
        {
          transportation_capacity: housing_request.transportation_capacity
        }
      ]
    end

    it 'renders fields on a relationship' do
      result = subject.call([housing_request], [registrations: [:attendee_name]], serializer: ::Api::HousingRequestSerializableResource)

      expect(result).to eq [
        {
          attendee_name: housing_request.registration.attendee_name
        }
      ]
    end
  end
end
