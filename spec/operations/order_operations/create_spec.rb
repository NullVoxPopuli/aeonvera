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

    context 'is not logged in' do
      let(:payment_token) { 'some-token' }

      before(:each) do
        params = {
          payment_token: payment_token,
          paid: false,
          user_email: 'oeu',
          user_name: 'aoeu oaeu',
          host_id: organization.id,
          host_type: organization.class.name
        }

        @operation = klass.new(nil, params, params)
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

      it 'does not mark the order as paid' do
        order = @operation.run
        expect(order.paid).to eq false
      end
    end

    context 'is logged in' do
      # loggedin-ness is represented with the user param on the operation
      # this is null when not logged in
      let(:user) { create(:user) }

      before(:each) do
        params = {
          user_email: 'someone@test.com',
          user_name: ' ',
          host_id: organization.id,
          host_type: organization.class.name
        }

        @operation = klass.new(user, params, params)
      end

      it 'creates a membership renewal' do
        expect { @operation.run }.to change(Order, :count).by(1)
      end

      it 'does not mark the order as paid' do
        order = @operation.run
        expect(order.paid).to eq false
      end
    end
  end

  context 'events' do
    let(:user) { create(:user) }
    let(:event) { create(:event) }
    let(:params) {
      {
        user_email: 'someone@test.com',
        user_name: 'some name',
        host_id: event.id,
        host_type: event.class.name
      }
    }

    context 'with a package and discount for that package' do
      before(:each) do
        @operation = klass.new(user, params, params)
      end

      it 'stores the buyer_name and buyer_email' do
        order = @operation.run
        expect(order.buyer_email).to eq 'someone@test.com'
        expect(order.buyer_name).to eq 'some name'
      end

      it 'does not mark the order as paid' do
        order = @operation.run
        expect(order.paid).to eq false
      end
    end
  end
end
