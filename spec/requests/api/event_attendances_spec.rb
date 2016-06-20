require 'rails_helper'

describe Api::EventAttendancesController, type: :request do
  before(:each) do
    host! APPLICATION_CONFIG[:domain][Rails.env]
  end

  context 'is logged in' do
    let(:user) { create_confirmed_user }
    before(:each) do
      @headers = {
        'Authorization' => 'Bearer ' + user.authentication_token
      }
    end

    context 'creating a housing request' do
      let(:event) { create(:event) }
      let(:package) { create(:package, event: event) }
      let(:params) do
        {"data": {
          "attributes": {
            "package-id": nil,"amount-owed": nil,"amount-paid": nil,"checked-in-at": nil,"attendee-name": nil,"dance-orientation": "Lead","registered-at": nil,"package-name": nil,"level-name": nil,"interested-in-volunteering": nil,"event-id": nil,"phone-number": nil,"address1": nil,"address2": nil,"city": "Fishers","state": "IN","zip": nil
          },
          "relationships": {
            "level": {"data": nil},
            "package": {"data": {"type": "packages","id": package.id}},
            "attendee": {"data": nil},
            "pricing-tier": {"data": nil},
            "host": {"data": {"type": "events","id": event.id}},
            "orders": {"data": [{"type": "orders","id": nil}]},
            "unpaid-order": {"data": nil},
            "housing-request": {
              "data": {
                "attributes": {
                  "need-transportation": true,
                  "can-provide-transportation": true,
                  "transportation-capacity": 2,
                  "allergic-to-pets": true,
                  "allergic-to-smoke": true,
                  "other-allergies": "Dairy",
                  "preferred-gender-to-house-with": "No Preference",
                  "notes": nil,
                  "requested-roommates": ["a","b","c","d"],
                  "unwanted-roommates": ["e","f","g","h"]
                },
                "relationships": {
                  "host": {"data": nil},
                  "attendance": {"data": {"type": "event-attendances","id": nil}},
                  "housing-provision": {"data": nil}
                },
                "type": "housing-requests"
              }
            },
            "housing-provision": {},
            },"type": "event-attendances"}}
      end

      it 'is created' do
        expect{
          post "/api/event_attendances", params, @headers
          expect(response.status).to eq 200
        }.to change(HousingRequest, :count).by(1)
      end

      it 'correctly sets the attendance relationship' do
        post "/api/event_attendances", params, @headers

        attendance_id = json_api_data['id']
        housing_request_id = json_api_data['relationships']['housing-request']['data']['id']

        hr = HousingRequest.find(housing_request_id)
        a = Attendance.find(attendance_id)
        expect(hr.attendance).to eq a
      end

      it 'correctly sets the host relationship' do
        post "/api/event_attendances", params, @headers

        event_id = json_api_data['relationships']['host']['data']['id']
        housing_request_id = json_api_data['relationships']['housing-request']['data']['id']

        hr = HousingRequest.find(housing_request_id)
        e = Event.find(event_id)
        expect(hr.host).to eq e
      end
    end
  end
end
