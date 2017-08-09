# frozen_string_literal: true

require 'spec_helper'

describe APIController do
  let(:controller) { APIController.new }
  let(:params) {
    { 'data' => {
      'attributes' => {
        'host-name' => nil, 'host-url' => nil, 'created-at' => nil, 'payment-received-at' => nil,
        'paid-amount' => nil, 'net-amount-received' => nil, 'total-fee-amount' => nil,
        'payment-method' => nil,
        'payment-token' => '123',
        'check-number' => nil, 'paid' => false, 'total-in-cents' => nil,
        'user-email' => 'oeu', 'user-name' => 'aoeu oaeu', 'checkout-token' => nil,
        'checkout-email' => nil
      },
      'relationships' => {
        'host' => { 'data' => { 'type' => 'organizations', 'id' => 1 } },
        'order-line-items' => { 'data' => [{
          'attributes' => {
            'quantity' => 1, 'price' => 45, 'partner-name' => nil, 'dance-orientation' => nil,
            'size' => nil, 'payment-token' => nil
          },
          'relationships' => {
            'line-item' => { 'data' => { 'type' => 'lessons', 'id' => 2 } },
            'order' => { 'data' => { 'type' => 'orders', 'id' => nil } }
          },
          'type' => 'order-line-items'
        }, {
          'attributes' => {
            'quantity' => 1, 'price' => 45, 'partner-name' => nil, 'dance-orientation' => nil,
            'size' => nil, 'payment-token' => nil
          },
          'relationships' => {
            'line-item' => { 'data' => { 'type' => 'lessons', 'id' => 3 } },
            'order' => { 'data' => { 'type' => 'orders', 'id' => nil } }
          },
          'type' => 'order-line-items'
        }] },
        'registration' => { 'data' => nil },
        'user' => { 'data' => nil }
      },
      'type' => 'orders'
    }, 'order' => {} }
  }

  before(:each) do
    allow(controller).to receive(:params) { params }
  end

  describe '#whitelistable_params' do
    it 'converts to snake case' do
      whitelisted = controller.send(:whitelistable_params)
      expect(whitelisted).to have_key(:user_email)
    end

    it 'whitelists attributes' do
      whitelisted = controller.send(:whitelistable_params) do |whitelister|
        whitelister.permit(:user_email)
      end

      expect(whitelisted.keys.count).to eq 1
      expect(whitelisted).to have_key(:user_email)
    end

    it 'includes polymorphic attributes' do
      whitelisted = controller.send(:whitelistable_params, polymorphic: [:host]) do |whitelister|
        whitelister.permit(:host_id, :host_type)
      end

      expect(whitelisted).to have_key(:host_id)
      expect(whitelisted).to have_key(:host_type)
    end

    it 'includes embedded attributes' do
      whitelisted = controller.send(:whitelistable_params, embedded: [:order_line_items]) do |whitelister|
        whitelister.permit(order_line_items_attributes: [:price])
      end

      expect(whitelisted).to have_key(:order_line_items_attributes)
    end
  end
end
