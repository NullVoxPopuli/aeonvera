require 'rails_helper'

describe Api::HousingProvisionsController, type: :request do
  before(:each) do
    host! APPLICATION_CONFIG[:domain][Rails.env]
  end

  context 'logged in' do
    context 'owns the event' do
      before(:each) do
        user = create_confirmed_user
        auth_header_for(user)
        @event = create(:event, hosted_by: user)
        @attendance = create(:attendance, host: @event)
        @housing_provision = create(:housing_provision, host: @event, attendance: @attendance)
        create(:housing_provision, host: @event, attendance: @attendance)
      end

      it 'can read all' do
        get "/api/housing_provisions.csv?event_id=#{@event.id}", {}, @headers
        expect(response.status).to eq 200
      end

      it 'selects attributes' do
        get "/api/housing_provisions.csv?event_id=#{@event.id}&fields=housingCapacity,numberOfShowers,attendance.attendeeName", {}, @headers
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
            "data"=>{
              "attributes"=>{"housing-capacity"=>0, "number-of-showers"=>0, "can-provide-transportation"=>false, "transportation-capacity"=>0, "preferred-gender-to-host"=>"No Preference", "has-pets"=>false, "smokes"=>false, "notes"=>nil, "name"=>nil},
              "relationships"=>{"host"=>{"data"=>{"type"=>"events", "id"=> @event.id}}, "attendance"=>{"data"=>{"type"=>"event-attendances", "id"=>@attendance.id}}},
              "type"=>"housing-provisions"
            }
          }
        end

        it 'creates' do
          expect {
            post '/api/housing_provisions', payload, @headers
            expect(response.status).to eq 201
          }.to change(HousingProvision, :count).by 1
        end

        it 'is tied to the attendance' do
          post '/api/housing_provisions', payload, @headers
          id = json_api_data['id']
          expect(HousingProvision.find(id).attendance).to eq @attendance
        end
      end
    end
  end
end
