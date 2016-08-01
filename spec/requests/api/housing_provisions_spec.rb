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
        create(:housing_provision, host: @event)
        create(:housing_provision, host: @event)
      end

      it 'can read all' do
        get "/api/housing_provisions.csv?event_id=#{@event.id}", {}, @headers
        expect(response.status).to eq 200
      end

      it 'selects attributes' do
        get "/api/housing_provisions.csv?event_id=#{@event.id}&fields=housingCapacity,numberOfShowers,attendance.attendeeName", {}, @headers
        expect(response.status).to eq 200
      end
    end
  end
end
