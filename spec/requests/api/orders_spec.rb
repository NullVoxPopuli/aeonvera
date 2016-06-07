require 'rails_helper'

describe Api::OrdersController, type: :request do
  before(:each) do
    host! APPLICATION_CONFIG[:domain][Rails.env]
  end

  context 'is not logged in' do
    let(:order) { create(:order, attendance: create(:attendance)) }
    it 'cannot view an existing order' do
      get "/api/orders/#{order.id}"
      expect(response.status).to eq 404
    end
  end

  context 'is logged in' do
    let(:user) { create_confirmed_user }
    before(:each) do
      @headers = {
        'Authorization' => 'Bearer ' + user.authentication_token
      }
    end

    it 'cannot view someone elses order' do
      order = create(:order, attendance: create(:attendance))
      get "/api/orders/#{order.id}", {}, @headers
      expect(response.status).to eq 404
    end

    it 'can view own order' do
      order = create(:order, user: user, attendance: create(:attendance, attendee: user))
      get "/api/orders/#{order.id}", {}, @headers
      expect(response.status).to eq 200
    end

    it 'can view the order of an owned event' do
      event = create(:event, hosted_by: user)
      order = create(:order, host: event, attendance: create(:attendance, attendee: user))
      get "/api/orders/#{order.id}", {}, @headers
      expect(response.status).to eq 200
    end
  end
end
