require 'spec_helper'

describe OrderOperations do

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
        operation = OrderOperations::Create.new(user, { order: {payment_method: Payable::Methods::STRIPE }})
        operation.build_order(host)

        expect{ operation.save_order }.to change(Order, :count).by 1
      end

      it 'is valid' do
        user = create(:user)
        host = create(:organization)
        item = create(:lesson, host: host)
        operation = OrderOperations::Create.new(user, { order: { payment_method: Payable::Methods::STRIPE }})
        operation.build_order(host)
        operation.build_items([{
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
        operation = OrderOperations::Create.new(user, { order: { payment_method: Payable::Methods::STRIPE }})
        operation.build_order(host)
        operation.build_items([{
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

end
