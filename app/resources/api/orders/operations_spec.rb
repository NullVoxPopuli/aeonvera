# frozen_string_literal: true

require 'spec_helper'

describe Api::OrderOperations do
  context 'SendReceipt' do
    context 'run' do
      it 'is allowed' do
        registration = create(:registration)
        order = create(:order, registration: registration)

        operation = Api::OrderOperations::SendReceipt.new(order.user, { id: order.id })
        allow(operation).to receive(:allowed?) { true }

        expect {
          operation.run
        }.to change(ActionMailer::Base.deliveries, :count).by 1
      end
    end
  end
end
