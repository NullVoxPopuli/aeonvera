require 'rails_helper'

describe Api::HousingRequestsController, type: :request do
  before(:each) do
    host! APPLICATION_CONFIG[:domain][Rails.env]
  end

  context 'logged in' do
    context 'owns the event' do
      before(:each) do
        user = create_confirmed_user
        auth_header_for(user)
        @event = create(:event, hosted_by: user)
        create(:housing_request, host: @event)
        create(:housing_request, host: @event)
      end

      it 'can read all' do
        get "/api/housing_requests?event_id=#{@event.id}", {}, @headers
        expect(response.status).to eq 200
      end
    end
  end
end
