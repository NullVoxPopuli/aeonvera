# frozen_string_literal: true
require 'rails_helper'

describe Api::OrderLineItemsController, type: :request do
  before(:each) do
    host! APPLICATION_CONFIG[:domain][Rails.env]
  end

  let(:event) { create(:event) }

  context 'is logged in' do
    let(:user) { create_confirmed_user }

    context 'user owns the order' do
      let(:order) { create(:order, host: event, attendance: create(:attendance, host: event), user: user) }

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
                  data: { type: 'discounts', id: discount.id } },
                order: {
                  data: { type: 'orders', id: order.id }
                }
              },
              "type": 'order-line-items'
            }
          }

          post '/api/order_line_items', params, auth_header_for(user)
          # includes the discount, and the discount's restraints
          expect(json_api_included.length).to eq 2
        end
      end
    end
  end
end
