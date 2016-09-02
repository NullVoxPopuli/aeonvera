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

    it 'cannot mark paid' do
      put "/api/orders/#{order.id}/mark_paid", { payment_method: 'Cash', amount: 10, check_number: '' }
      expect(response.status).to eq 401
    end

    it 'cannot refresh stripe data' do
      get "/api/orders/#{order.id}/refresh_stripe"
      expect(response.status).to eq 401
    end

    it 'cannot delete' do
      delete "/api/orders/#{order.id}"
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
      package = create(:package, event: event)
      create(:order_line_item, order: order, line_item: package)
      order.reload
      put "/api/orders/#{order.id}/refund_payment", { refund_type: 'full' }, auth_header_for(owner)
      expect(response.status).to eq 200
    end

    it 'can mark paid' do
      put "/api/orders/#{order.id}/mark_paid", { payment_method: 'Cash', amount: 10, check_number: '' }, auth_header_for(owner)
      expect(response.status).to eq 200
      expect(json_api_data['attributes']['paid']).to eq true
    end

    it 'can refresh stripe data' do
      get "/api/orders/#{order.id}/refresh_stripe", {}, auth_header_for(owner)
      expect(response.status).to eq 200
    end

    it 'can delete an unpaid order' do
      package = create(:package, event: event)
      add_to_order(order, package, price: 2)
      order.paid = false
      order.save
      expect(order.paid).to eq false
      delete "/api/orders/#{order.id}", {}, auth_header_for(owner)
      expect(response.status).to eq 200
    end

    it 'cannot delete a paid order' do
      package = create(:package, event: event)
      add_to_order(order, package, price: 2)
      order.mark_paid!({})
      expect(order.paid).to eq true
      delete "/api/orders/#{order.id}", {}, auth_header_for(owner)
      expect(response.status).to eq 404
    end
  end

  context 'is logged in' do
    let(:user) { create_confirmed_user }

    it 'cannot view someone elses order' do
      order = create(:order, attendance: create(:attendance))
      get "/api/orders/#{order.id}", {}, auth_header_for(user)
      expect(response.status).to eq 404
    end

    it 'cannot refund someone elses order' do
      order = create(:order, attendance: create(:attendance))
      put "/api/orders/#{order.id}/refund_payment", { refund_type: 'full' }, auth_header_for(user)
      expect(response.status).to eq 404
    end

    it 'can view own order' do
      order = create(:order, user: user, attendance: create(:attendance, attendee: user))
      get "/api/orders/#{order.id}", {}, auth_header_for(user)
      expect(response.status).to eq 200
    end

    it 'cannot refund own order' do
      order = create(:order, user: user, attendance: create(:attendance, attendee: user))
      put "/api/orders/#{order.id}/refund_payment", { refund_type: 'full' }, auth_header_for(user)
      expect(response.status).to eq 404
    end

    it 'can view the order of an owned event' do
      event = create(:event, hosted_by: user)
      order = create(:order, host: event, attendance: create(:attendance, attendee: user))
      get "/api/orders/#{order.id}", {}, auth_header_for(user)
      expect(response.status).to eq 200
    end
  end
end
