require 'spec_helper'

describe OrderOperations do

  context 'SendReceipt' do
    context 'run' do
      it 'is allowed' do
        attendance = create(:attendance)
        order = create(:order, attendance: attendance)

        operation = OrderOperations::SendReceipt.new(order.user, {id: order.id})
        allow(operation).to receive(:allowed?){ true }

        expect{
          operation.run
        }.to change(ActionMailer::Base.deliveries, :count).by 1
      end
    end
  end

  context 'Create' do
    context 'run' do
      it 'sends a payment received email' do

      end

      it 'has errors' do

      end
    end

    context 'build_order' do
      it 'has a validation error on an item' do

      end

      it 'is valid' do

      end

    end

    context 'save_order' do
      it 'can be saved' do
        user = create(:user)
        host = create(:organization)
        operation = OrderOperations::Create.new(user, {})
        operation.build_order(host, [])

        expect{ operation.save_order }.to change(Order, :count).by 1
      end

      it 'is valid' do
        user = create(:user)
        host = create(:organization)
        item = create(:lesson, host: host)
        operation = OrderOperations::Create.new(user, {})
        operation.build_order(host, [{
          lineItemId: item.id,
          lineItemType: item.class.name,
          price: 4,
          quantity: 1
        }])

        expect(operation.model.errors.full_messages).to be_empty
      end

      it 'can save the relationships as well' do
        user = create(:user)
        host = create(:organization)
        item = create(:lesson, host: host)
        operation = OrderOperations::Create.new(user, {})
        operation.build_order(host, [{
          lineItemId: item.id,
          lineItemType: item.class.name,
          price: 4,
          quantity: 1
        }])

        expect{ operation.save_order }.to change(OrderLineItem, :count).by 1
      end
    end

    context 'create!' do
      it 'builds an order' do

      end

      it 'marks as paid when the sub total is 0' do

      end

      it 'charges the credit card' do
        # TODO: remember StripeMock
      end
    end
  end

  context 'Update' do
    context 'run' do
      it 'is allowed' do
        skip('what conditions can an order be updated?')
      end

      it 'calls update' do
        operation = OrderOperations::Update.new(nil, {})
        allow(operation).to receive(:allowed?){ true }
        expect(operation).to receive(:update)

        operation.run
      end

      it 'is not allowed' do
        skip('what conditions can an order not be updated?')
      end
    end

    context 'update' do
      let(:stripe_helper) { StripeMock.create_test_helper }
      before { StripeMock.start }
      after { StripeMock.stop }

      before(:each) do
        @event = event = create_event
        package = create(:package, event: event)
        integration = create_integration(owner: event)
        @order = create(:order, host: event)
        @order.add(package)

        @params = {
          id: @order.id,
          order: {
            payment_method: Payable::Methods::STRIPE,
            paid_amount: 13.37
          },
          stripe: {
            checkout_token: stripe_helper.generate_card_token,
            checkout_email: 'test@test.com'
          }
        }

        @operation = OrderOperations::Update.new(event.hosted_by, @params)
      end

      context 'for a check' do
        before(:each) do
          @params[:order][:payment_method] = Payable::Methods::CHECK
          @params[:order][:check_number] = @check_number = '1245'
        end

        it 'sets the check number' do
          order = @operation.run
          expect(order.check_number).to eq @check_number
        end

        it 'sets payment information' do
          order = @operation.run

          expect(order.paid).to be_truthy
          expect(order.paid_amount).to eq @params[:order][:paid_amount]
          expect(order.net_amount_received).to eq order.paid_amount
          expect(order.total_fee_amount).to eq 0
          expect(order.errors).to be_empty
        end
      end

      context 'for a stripe order' do

        context 'errors' do
          it 'when no checkout token is provided' do
            @params[:stripe].delete(:checkout_token)
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

end
