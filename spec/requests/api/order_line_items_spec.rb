# frozen_string_literal: true
require 'rails_helper'

describe Api::OrderLineItemsController, type: :request do
  include RequestSpecUserSetup

  before(:each) do
    host! APPLICATION_CONFIG[:domain][Rails.env]
  end

  context 'is logged in' do
    let(:order) {
      create(:order, host: event, attendance: create(:attendance, host: event), user: stray_user)
    }

    context 'user owns the event' do
      it 'can mark as picked up' do
        package = create(:package, event: event)
        oli = add_to_order(order, package)
        order.save

        put "/api/order_line_items/#{oli.id}/mark_as_picked_up", {}, auth_header_for(owner)
        expect(response.status).to eq 200
      end
    end

    context 'user owns the order' do
      before(:each) { auth_header_for(stray_user) }

      it 'cannot mark as picked up' do
        package = create(:package, event: event)
        oli = add_to_order(order, package)
        order.save

        put "/api/order_line_items/#{oli.id}/mark_as_picked_up", {}, @headers
        expect(response.status).to eq 404
      end

      it 'can delete' do
        package = create(:package, event: event)
        oli = add_to_order(order, package)
        order.save

        expect {
          delete "/api/order_line_items/#{oli.id}", {}, @headers
          expect(response.status).to eq 200
        }.to change(OrderLineItem, :count).by(-1)
      end

      context 'when creating an order line item' do
        it 'includes the discount and restraints in the response' do
          # add a package to the order that we can apply the discount to
          package = create(:package, event: event)
          add_to_order!(order, package)
          discount = create(:discount, host: event, kind: Discount::PERCENT_OFF, value: 100)
          create(:restraint, dependable: discount, restrictable: package)

          params = {
            data: {
              attributes: { quantity: 1, price: 0 - discount.value },
              relationships: {
                'line-item' => {
                  data: { type: 'discounts', id: discount.id }
                },
                order: {
                  data: { type: 'orders', id: order.id }
                }
              },
              "type": 'order-line-items'
            }
          }

          post '/api/order_line_items', params, @headers
          # includes the discount, and the discount's restraints
          expect(json_api_included.length).to eq 2
        end
      end
    end
  end

  context 'is not logged in' do
  end
end
