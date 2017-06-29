# frozen_string_literal: true
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

    context 'but does have a payment_token' do
      let(:token) { 'abc123' }

      it 'cannot view all orders' do
        get '/api/orders', { payment_token: token }

        expect(response.status).to eq 404
      end

      it 'orders from others are not included' do
        create(:order)
        get '/api/orders', { payment_token: token }

        json = JSON.parse(response.body)
        errors = json['errors']
        data = json['data']

        expect(data).to be_nil
        expect(errors).to_not be_empty
      end

      it 'cannot view someone elses order' do
        o = create(:order)

        get "/api/orders/#{o.id}", { payment_token: token }

        json = JSON.parse(response.body)
        expect(response.status).to eq 404
        expect(json['data']).to be_nil
      end

      it 'cannot refund someone elses order' do
        order = create(:order, attendance: create(:attendance))
        put "/api/orders/#{order.id}/refund_payment", { refund_type: 'full', payment_token: token }
        expect(response.status).to eq 404
      end

      it 'can view own order' do
        order = create(:order, payment_token: token)

        get "/api/orders/#{order.id}", { payment_token: token }

        json = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(json['data']).to_not be_nil
      end

      it 'cannot refund own order' do
        order = create(:order, payment_token: token)
        put "/api/orders/#{order.id}/refund_payment", { refund_type: 'full', payment_token: token }
        expect(response.status).to eq 404
      end

      it 'can delete unpaid order' do
        order = create(:order, payment_token: token)
        expect(order.paid).to eq false

        delete "/api/orders/#{order.id}", { payment_token: token }

        expect(response.status).to eq 200
      end

      it 'can not delete paid order' do
        order = create(:order, payment_token: token, paid: true)
        expect(order.paid).to eq true

        delete "/api/orders/#{order.id}", { payment_token: token }

        expect(response.status).to eq 200
      end
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

    it 'can view all their orders' do
      create(:order, user: user, attendance: create(:attendance, attendee: user))
      get '/api/orders', {}, auth_header_for(user)
      expect(response.status).to eq 200
      expect(json_api_data.count).to eq 1
    end

    it 'orders from others are not included' do
      create(:order, attendance: create(:attendance))
      get '/api/orders', {}, auth_header_for(user)
      expect(json_api_data).to be_empty
    end

    it 'cannot view someone elses order' do
      order = create(:order, attendance: create(:attendance))
      get "/api/orders/#{order.id}", {}, auth_header_for(user)
      expect(response.status).to eq 404
    end

    context 'can create an order' do
      let(:organization) { create(:organization) }
      let(:params) { {
        data: {
          type: 'order',
          attributes: {},
          relationships: {
            host: { data: { type: 'Organization', id: organization.id } }
          }
        }
      } }

      it 'can create an order' do
        expect { post '/api/orders', params, auth_header_for(user) }
          .to change(Order, :count).by 1
        expect(response.status).to eq 200
      end

      it 'can create an order - blank payment_token is ignored' do
        post '/api/orders', params, auth_header_for(user)
        expect(response.status).to eq 200
      end
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

    context 'can pay for own order' do
      let!(:organization) { create(:organization) }
      let!(:user) { create(:user) }
      let!(:order) { create(:order, host: organization, user: user, payment_method: Payable::Methods::STRIPE) }
      let!(:lesson) { create(:lesson, host: organization, price: 45) }

      context 'when buying a membership option' do
        let!(:membership_option) { create(:membership_option, host: organization, price: 25) }
        let!(:membership_discount) {
          create(:membership_discount,
            host: organization,
            value: 7,
            affects: LineItem::Lesson.name,
            kind: Discount::DOLLARS_OFF)
        }

        before(:each) do
          add_to_order!(order, lesson)
          add_to_order!(order, membership_option)
          Api::OrderOperations::AddAutomaticDiscounts.new(order).run

          order.reload
          expect(order.order_line_items.count).to eq 3
        end

        let(:stripe_successful_payment_params) do
          {
            'data' => {
              'id' => '3385',
              'attributes' => {
                'paid_amount' => 53,
                'payment_method' => Payable::Methods::STRIPE,
                'checkout-token' => 'tok_some_payment_token',
                'checkout-email' => 'preston@aeonvera.com'
              },
              'relationships' => {
                'host' => { 'data' => { 'type' => 'organizations', 'id' => '1' } },
                'order-line-items' => {
                  'data' => [
                    { 'id' => '4625', 'type' => 'order-line-items' },
                    { 'id' => '4624', 'type' => 'order-line-items' },
                    { 'id' => '4623', 'type' => 'order-line-items' }
                  ]
                },
                'attendance' => { 'data' => nil },
                'user' => { 'data' => { 'type' => 'users', 'id' => 'current-user' } },
                'pricing-tier' => { 'data' => nil }
              },
              'type' => 'orders'
            }
          }
        end

        before(:each) do
          # 'disable' the stripe stuff -- not tested here
          allow_any_instance_of(Order).to receive(:sync_current_payment_aggregations)
          allow_any_instance_of(Api::OrderOperations::Update).to receive(:update_stripe) {
            order.update(
              paid: true,
              net_amount_received: -1,
              paid_amount: -1,
              total_fee_amount: -1
            )
          }
        end

        it 'makes sure that the param input is valid for paying for an order' do
          expect {
            patch "/api/orders/#{order.id}", stripe_successful_payment_params, auth_header_for(user)
          }.to change(order, :paid)
        end

        it 'creates a membership renewal' do
          expect {
            patch "/api/orders/#{order.id}", stripe_successful_payment_params, auth_header_for(user)
          }.to change(MembershipRenewal, :count).by(1)
        end

        it 'makes the user a member of the organization' do
          expect(user.is_member_of?(organization)).to eq false

          patch "/api/orders/#{order.id}", stripe_successful_payment_params, auth_header_for(user)

          expect(user.is_member_of?(organization)).to eq true
        end
      end
    end
  end
end
