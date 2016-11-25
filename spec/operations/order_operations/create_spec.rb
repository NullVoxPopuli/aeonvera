# frozen_string_literal: true
require 'spec_helper'

describe Api::OrderOperations::Create do
  let(:klass) { Api::OrderOperations::Create }
  # This is only for the parameter mapping
  let(:controller) { Api::OrdersController.new }

  context 'organizations' do
    let(:organization) { create(:organization) }
    let(:lesson) { create(:lesson, host: organization) }
    let(:lesson2) { create(:lesson, host: organization) }

    context 'is not logged in - two lessons' do
      let(:payment_token) { 'some-token' }
      let(:params) do
        { 'data' => {
          'attributes' => {
            'host-name' => nil, 'host-url' => nil, 'created-at' => nil, 'payment-received-at' => nil,
            'paid-amount' => nil, 'net-amount-received' => nil, 'total-fee-amount' => nil,
            'payment-method' => nil,
            'payment-token' => payment_token,
            'check-number' => nil, 'paid' => false, 'total-in-cents' => nil,
            'user-email' => 'oeu', 'user-name' => 'aoeu oaeu', 'checkout-token' => nil,
            'checkout-email' => nil },
          'relationships' => {
            'host' => { 'data' => { 'type' => 'organizations', 'id' => organization.id } },
            'order-line-items' => { 'data' => [{
              'attributes' => {
                'quantity' => 1, 'price' => 45, 'partner-name' => nil, 'dance-orientation' => nil,
                'size' => nil, 'payment-token' => nil },
              'relationships' => {
                'line-item' => { 'data' => { 'type' => 'lessons', 'id' => lesson.id } },
                'order' => { 'data' => { 'type' => 'orders', 'id' => nil } } },
              'type' => 'order-line-items' }, {
                'attributes' => {
                  'quantity' => 1, 'price' => 45, 'partner-name' => nil, 'dance-orientation' => nil,
                  'size' => nil, 'payment-token' => nil },
                'relationships' => {
                  'line-item' => { 'data' => { 'type' => 'lessons', 'id' => lesson2.id } },
                  'order' => { 'data' => { 'type' => 'orders', 'id' => nil } } },
                'type' => 'order-line-items' }] },
            'attendance' => { 'data' => nil },
            'user' => { 'data' => nil } },
          'type' => 'orders' }, 'order' => {} }
      end

      before(:each) do
        allow(controller).to receive(:params) { params }
        params_for_action = controller.send(:create_order_params)

        @operation = klass.new(nil, params, params_for_action)
        @payment_token = payment_token
      end

      it 'has a token' do
        model = @operation.run
        expect(model.payment_token).to eq @payment_token
      end

      it 'is valid' do
        model = @operation.run
        expect(model.errors.full_messages).to be_empty
      end

      it 'creates an order' do
        expect do
          @operation.run
        end.to change(Order, :count).by(1)
      end

      it 'creates two order line items' do
        expect do
          @operation.run
        end.to change(OrderLineItem, :count).by(2)
      end
    end

    context 'is logged in' do
      # loggedin-ness is represented with the user param on the operation
      # this is null when not logged in
      let(:user) { create(:user) }

      context 'purchasing a membership' do
        let(:membership_option) { create(:membership_option, host: organization) }

        let(:basic_params) do
          { 'data' => {
            'attributes' => {
              'host-name' => nil, 'host-url' => nil, 'created-at' => nil, 'payment-received-at' => nil, 'paid-amount' => nil, 'net-amount-received' => nil, 'total-fee-amount' => nil, 'payment-method' => nil, 'payment-token' => nil, 'check-number' => nil, 'paid' => false, 'total-in-cents' => nil,
              'user-email' => 'someone@test.com', 'user-name' => ' ', 'checkout-token' => nil, 'checkout-email' => nil },
            'relationships' => {
              'host' => { 'data' => { 'type' => 'organizations', 'id' => organization.id } },
              'order-line-items' => { 'data' => [
                {
                  'attributes' => { 'quantity' => 1, 'price' => membership_option.price, 'partner-name' => nil, 'dance-orientation' => nil, 'size' => nil, 'payment-token' => nil },
                  'relationships' => {
                    'line-item' => { 'data' => { 'type' => 'membership-options', 'id' => membership_option.id } },
                    'order' => { 'data' => { 'type' => 'orders', 'id' => nil } } },
                  'type' => 'order-line-items' }
              ] },
              'attendance' => {},
              'user' => { 'data' => { 'type' => 'users', 'id' => 'current-user' } } }, 'type' => 'orders' },
            'order' => {} }
        end

        before(:each) do
          allow(controller).to receive(:params) { basic_params }
          params_for_action = controller.send(:create_order_params)

          @operation = klass.new(user, basic_params, params_for_action)
        end

        it 'creates a membership renewal' do
          expect { @operation.run }.to change(MembershipRenewal, :count).by(1)
        end
      end
    end
  end

  context 'events' do
    let(:user) { create(:user) }
    let(:event) { create(:event) }
    let(:package) { create(:package, event: event) }
    let(:attendance) { create(:attendance, host: event, package: package, attendee: user) }
    let(:competition) { create(:competition, event: event, kind: Competition::SOLO_JAZZ) }

    context 'with a package and discount for that package' do
      let(:discount) { create(:discount, host: event, amount: 20, kind: Discount::DOLLARS_OFF) }
      let(:basic_params) do
        { 'data' => {
          'attributes' => {
            'host-name' => nil, 'host-url' => nil, 'created-at' => nil, 'payment-received-at' => nil, 'paid-amount' => nil, 'net-amount-received' => nil, 'total-fee-amount' => nil, 'payment-method' => nil, 'payment-token' => nil, 'check-number' => nil, 'paid' => false, 'total-in-cents' => nil,
            'user-email' => 'someone@test.com', 'user-name' => 'some name', 'checkout-token' => nil, 'checkout-email' => nil },
          'relationships' => {
            'host' => { 'data' => { 'type' => 'events', 'id' => event.id } },
            'order-line-items' => { 'data' => [
              {
                'attributes' => { 'quantity' => 1, 'price' => package.current_price, 'partner-name' => nil, 'dance-orientation' => nil, 'size' => nil, 'payment-token' => nil },
                'relationships' => {
                  'line-item' => { 'data' => { 'type' => 'packages', 'id' => package.id } },
                  'order' => { 'data' => { 'type' => 'orders', 'id' => nil } } },
                'type' => 'order-line-items' },
              {
                'attributes' => { 'quantity' => 1, 'price' => 0 - discount.amount, 'partner-name' => nil, 'dance-orientation' => nil, 'size' => nil, 'payment-token' => nil },
                'relationships' => {
                  'line-item' => { 'data' => { 'type' => 'discounts', 'id' => discount.id } },
                  'order' => { 'data' => { 'type' => 'orders', 'id' => nil } } },
                'type' => 'order-line-items' }
            ] },
            'attendance' => { 'data' => { 'type' => 'event-attendances', 'id' => attendance.id } },
            'user' => { 'data' => { 'type' => 'users', 'id' => 'current-user' } } }, 'type' => 'orders' },
          'order' => {} }
      end

      before(:each) do
        allow(controller).to receive(:params) { basic_params }
        params_for_action = controller.send(:create_order_params)

        @operation = klass.new(user, basic_params, params_for_action)
      end

      it 'creates order line items' do
        expect do
          @operation.run
        end.to change(OrderLineItem, :count).by(2)
      end

      it 'stores the buyer_name and buyer_email' do
        order = @operation.run
        expect(order.buyer_email).to eq 'someone@test.com'
        expect(order.buyer_name).to eq 'some name'
      end

      it 'reduced the price by 20 dollars' do
        order = @operation.run
        expect(order.sub_total).to eq(package.current_price - discount.amount)
      end

      it 'reduces the price, even when the discount is restraint to the package' do
        create(:restraint, dependable: discount, restrictable: package)
        order = @operation.run
        expect(order.sub_total).to_not eq(package.current_price)
        expect(order.sub_total).to eq(package.current_price - discount.amount)
      end

      it 'does not reduce the price if the discount is intended for a different package' do
        create(:restraint, dependable: discount, restrictable: create(:package, event: event))
        order = @operation.run
        expect(order.sub_total).to eq(package.current_price)
      end
    end

    context 'with a package and competition' do
      let(:competition) { create(:competition, event: event, kind: Competition::SOLO_JAZZ) }

      let(:basic_params) do
        { 'data' => {
          'attributes' => {
            'host-name' => nil, 'host-url' => nil, 'created-at' => nil, 'payment-received-at' => nil, 'paid-amount' => nil, 'net-amount-received' => nil, 'total-fee-amount' => nil, 'payment-method' => nil, 'payment-token' => nil, 'check-number' => nil, 'paid' => false, 'total-in-cents' => nil,
            'user-email' => 'someone@test.com', 'user-name' => ' ', 'checkout-token' => nil, 'checkout-email' => nil },
          'relationships' => {
            'host' => { 'data' => { 'type' => 'events', 'id' => event.id } },
            'order-line-items' => { 'data' => [
              {
                'attributes' => { 'quantity' => 1, 'price' => package.current_price, 'partner-name' => nil, 'dance-orientation' => nil, 'size' => nil, 'payment-token' => nil },
                'relationships' => {
                  'line-item' => { 'data' => { 'type' => 'packages', 'id' => package.id } },
                  'order' => { 'data' => { 'type' => 'orders', 'id' => nil } } },
                'type' => 'order-line-items' },
              {
                'attributes' => { 'quantity' => 1, 'price' => competition.current_price, 'partner-name' => nil, 'dance-orientation' => nil, 'size' => nil, 'payment-token' => nil },
                'relationships' => {
                  'line-item' => { 'data' => { 'type' => 'competitions', 'id' => competition.id } },
                  'order' => { 'data' => { 'type' => 'orders', 'id' => nil } } },
                'type' => 'order-line-items' }
            ] },
            'attendance' => { 'data' => { 'type' => 'event-attendances', 'id' => attendance.id } },
            'user' => { 'data' => { 'type' => 'users', 'id' => 'current-user' } } }, 'type' => 'orders' },
          'order' => {} }
      end

      before(:each) do
        allow(controller).to receive(:params) { basic_params }
        params_for_action = controller.send(:create_order_params)

        @operation = klass.new(user, basic_params, params_for_action)
      end

      it 'is valid' do
        model = @operation.run
        expect(model.errors.full_messages).to be_empty
      end

      it 'creates an order' do
        expect do
          @operation.run
        end.to change(Order, :count).by(1)
      end

      it 'creates order line items' do
        expect do
          @operation.run
        end.to change(OrderLineItem, :count).by(2)
      end

      it 'defaults to the stripe payment method' do
        model = @operation.run
        expect(model.payment_method).to eq Payable::Methods::STRIPE
      end

      it 'has a subtotal equal to the sum of the line items' do
        model = @operation.run
        expected = package.current_price + competition.current_price
        expect(model.sub_total).to eq expected
      end
    end

    context 'competition can be purchased without an attendance' do
      let(:params_for_action) do
        {
          host_id: event.id,
          host_type: Event.name,
          payment_method: nil,
          user_email: 'someone@test.com',
          user_name: 'first last',
          payment_token: nil,
          order_line_items_attributes: [
            {
              line_item_id: competition.id,
              line_item_type: Competition.name,
              price: competition.current_price,
              quantity: 1,
              partner_name: nil,
              dance_orientation: nil,
              size: nil
            }
          ]
        }
      end

      it 'creates the competition' do
        @operation = klass.new(user, params_for_action, params_for_action)
        expect { @operation.run }.to change(OrderLineItem, :count).by(1)
      end

      it 'requires a name' do
        params_for_action.delete(:user_name)
        @operation = klass.new(user, params_for_action, params_for_action)
        r = @operation.run
        expect(r.errors.full_messages.first).to include('name')
      end
    end

    context 'the total is 0 dollas' do
      let(:basic_params) do
        { 'data' => {
          'attributes' => {
            'host-name' => nil, 'host-url' => nil, 'created-at' => nil, 'payment-received-at' => nil, 'paid-amount' => nil, 'net-amount-received' => nil, 'total-fee-amount' => nil, 'payment-method' => nil, 'payment-token' => nil, 'check-number' => nil, 'paid' => false, 'total-in-cents' => nil,
            'user-email' => 'someone@test.com', 'user-name' => ' ', 'checkout-token' => nil, 'checkout-email' => nil },
          'relationships' => {
            'host' => { 'data' => { 'type' => 'events', 'id' => event.id } },
            'order-line-items' => { 'data' => [
              {
                'attributes' => { 'quantity' => 1, 'price' => 0, 'partner-name' => nil, 'dance-orientation' => nil, 'size' => nil, 'payment-token' => nil },
                'relationships' => {
                  'line-item' => { 'data' => { 'type' => 'packages', 'id' => package.id } },
                  'order' => { 'data' => { 'type' => 'orders', 'id' => nil } } },
                'type' => 'order-line-items' }
            ] },
            'attendance' => { 'data' => { 'type' => 'event-attendances', 'id' => attendance.id } },
            'user' => { 'data' => { 'type' => 'users', 'id' => 'current-user' } } }, 'type' => 'orders' },
          'order' => {} }
      end

      before(:each) do
        allow(controller).to receive(:params) { basic_params }
        params_for_action = controller.send(:create_order_params)

        @operation = klass.new(user, basic_params, params_for_action)
      end

      it 'marks as paid when the sub total is 0' do
        model = @operation.run
        expect(model.sub_total).to eq 0
        expect(model.paid).to eq true
      end

      it 'marks the payment method as cash' do
        model = @operation.run
        expect(model.payment_method).to eq Payable::Methods::CASH
      end
    end

    it 'charges the credit card' do
      # TODO: remember StripeMock
    end
  end
end
