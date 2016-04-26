require 'spec_helper'

describe OrderOperations::Update do
  let(:klass){ OrderOperations::Update }
  # This is only for the parameter mapping
  let(:controller){ Api::OrdersController.new }
  let(:user){ create(:user) }

  context 'with the intent to pay' do
    let(:event){ create_event }
    let(:attendance){ create(:attendance, event: event) }

    context 'run' do
      it 'is not allowed' do
        order = create(:order,
          host: event,
          user: nil,
          attendance: attendance,
          payment_token: nil,
          metadata: { name: 'a', email: 'a'})
        operation = OrderOperations::Update.new(nil, {
          id: order.id, payment_method: 'Stripe'
        })
        allow(operation).to receive(:update)

        operation.run
      end

      it 'is allowed' do
        order = create(:order,
          host: event,
          user: nil,
          attendance: attendance,
          payment_token: '123',
          payment_method: 'Stripe',
          metadata: { name: 'a', email: 'a'})
        operation = OrderOperations::Update.new(nil, {
          id: order.id, payment_token: '123', payment_method: 'Stripe'
        })
        allow(operation).to receive(:update)

        operation.run
      end

      it 'calls update' do
        @order = create(:order, host: event, attendance: attendance)
        operation = OrderOperations::Update.new(nil, {id: @order.id})
        allow(operation).to receive(:allowed?){ true }
        expect(operation).to receive(:update)

        operation.run
      end

      it 'is not allowed' do
        skip('what conditions can an order not be updated?')
      end

      it 'sends an email' do
        @order = create(:order, host: event, paid: false, attendance: attendance)
        package = create(:package, event: event)
        @order.order_line_items.create(line_item: package, price: package.current_price, quantity: 1)
        @order.save

        expect(@order.paid).to eq false
        operation = OrderOperations::Update.new(nil, {id: @order.id, payment_method: Payable::Methods::CASH, paid_amount: 10})

        expect{
            operation.run
        }.to change(ActionMailer::Base.deliveries, :count).by 1

      end
    end

    context 'update' do
      let(:stripe_helper) { StripeMock.create_test_helper }
      before { StripeMock.start }
      after { StripeMock.stop }

      before(:each) do
        package = create(:package, event: event)
        integration = create_integration(owner: event)
        @order = create(:order, host: event, attendance: attendance)
        @order.add(package)

        @params = {
          id: @order.id,
          payment_method: Payable::Methods::STRIPE,
          paid_amount: 13.37,
          checkout_token: stripe_helper.generate_card_token,
          checkout_email: 'test@test.com'
        }

        @operation = OrderOperations::Update.new(event.hosted_by, @params)
      end

      context 'for a check' do
        before(:each) do
          @params[:payment_method] = Payable::Methods::CHECK
          @params[:check_number] = @check_number = '1245'
        end

        it 'sets the check number' do
          order = @operation.run
          expect(order.check_number).to eq @check_number
        end

        it 'sets payment information' do
          order = @operation.run

          expect(order.paid).to be_truthy
          expect(order.paid_amount).to eq @params[:paid_amount]
          expect(order.net_amount_received).to eq order.paid_amount
          expect(order.total_fee_amount).to eq 0
          expect(order.errors).to be_empty
        end
      end

      context 'for a stripe order' do

        context 'errors' do
          it 'when no checkout token is provided' do
            @params.delete(:checkout_token)
            order = @operation.run
            expect(order.errors).to be_present
          end

          it 'when the stripe charge fails' do
            StripeMock.prepare_card_error(:card_declined)
            order = @operation.run
            expect(order.errors).to be_present
          end
        end


        it 'marks the order as paid' do
          order = @operation.run
          expect(order.paid?).to eq true
        end
      end
    end


  end

  context 'editing the contents of the order' do
    let(:event){ create(:event) }
    let(:package){ create(:package, event: event) }
    let(:competition){ create(:competition, event: event, kind: Competition::SOLO_JAZZ) }
    let(:attendance){ create(:attendance, host: event, package: package, attendee: user) }

    let(:order){ create(:order, host: event, user: user, attendance: attendance) }
    let(:item1){ create(:order_line_item, order: order, line_item: package, price: package.current_price, quantity: 1) }
    let(:item2){ create(:order_line_item, order: order, line_item: competition, price: competition.current_price, quantity: 1) }
  end


end
