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

    it 'cannot refund' do
      put "/api/orders/#{order.id}/refund_payment", { refund_type: 'full' }
      expect(response.status).to eq 401
    end

    it 'cannot refresh stripe data' do
      get "/api/orders/#{order.id}/refresh_stripe"
      expect(response.status).to eq 401
    end
  end

  context 'user owns the event' do
    let(:owner) { create_confirmed_user }
    let(:event) { create(:event, hosted_by: owner) }
    let(:order) { create(:order, host: event, attendance: create(:attendance, host: event)) }

    before { StripeMock.start }
    after { StripeMock.stop }

    it 'can refund' do
      put "/api/orders/#{order.id}/refund_payment", { refund_type: 'full' }, auth_header_for(owner)
      expect(response.status).to eq 200
    end

    it 'can refresh stripe data' do
      get "/api/orders/#{order.id}/refresh_stripe", {}, auth_header_for(owner)
      expect(response.status).to eq 200
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

    it
  end
end
