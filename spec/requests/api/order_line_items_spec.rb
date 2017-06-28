# frozen_string_literal: true
require 'rails_helper'

describe Api::OrderLineItemsController, type: :request do
  include RequestSpecUserSetup

  context 'Event: is logged in' do
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
        context 'of type: Package' do
          let(:package) { create(:package, event: event) }
          let(:params) { {
            data: {
              type: 'order-line-items',
              attributes: { quantity: 1, price: package.current_price },
              relationships: {
                'line-item': { data: { type: 'packages', id: package.id } },
                order: { data: { type: 'orders', id: order.id } }
              }
            }
          } }

          it 'can add an item to the order' do
            expect { post '/api/order_line_items', params, @headers }
              .to change(OrderLineItem, :count).by 1

            expect(response.status).to eq 201
          end

          it 'does not allow price forgery' do
            params[:data][:attributes][:price] = 0.01
            post '/api/order_line_items', params, @headers

            result = json_api_data['attributes']['price'].to_f
            expect(result).to eq package.current_price
          end

          it 'correctly adjusts the price with no prior items' do
            post '/api/order_line_items', params, @headers
            order.reload

            expect(order.order_line_items.length).to eq 1
            expect(order.sub_total).to eq package.current_price
          end

          it 'correctly adjusts the price with a prior item' do
            some_item = create(:line_item, price: 12, host: event)
            add_to_order!(order, some_item, price: 12)
            expect(order.order_line_items.length).to eq 1

            post '/api/order_line_items', params, @headers

            order.reload
            expect(order.order_line_items.length).to eq 2
            expect(order.sub_total).to eq package.current_price + 12
          end
        end

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
          # order, and order line items
          expect(json_api_included.length).to eq 5
        end
      end
    end
  end

  context 'Organization: is not logged in' do
    context 'user owns the order via payment token' do
      let(:order) { create(:order, host: organization, payment_token: '123abc') }
      let(:lesson1) { create(:lesson, host: organization) }

      context 'with an existing order-line-item' do
        let!(:oli) { create(:order_line_item, line_item: lesson1, order: order) }

        before(:each) { expect(order.order_line_items.count).to eq(1) }

        it 'can delete' do
          expect {
            delete(
              "/api/order_line_items/#{oli.id}",
              payment_token: '123abc'
            )

            expect(response.status).to eq 200
          }.to change(OrderLineItem, :count).by(-1)
        end

        it 'can update the quantity via patch' do
          patch(
            "/api/order_line_items/#{oli.id}",
            payment_token: '123abc',
            data: {
              id: oli.id,
              attributes: { quantity: 5 },
              relationships: {
                'line-item': { type: 'lessons', id: lesson1.id }
              }
            }
          )

          expect(response.status).to eq 200

          oli.reload

          expect(oli.quantity).to eq 5
        end

        it 'can update the quantity via post of same line item' do
          skip('the frontend must detect pre-existence and PATCH')
          params = {
            payment_token: '123abc',
            data: {
              type: 'order-line-items',
              attributes: { quantity: 1 },
              relationships: {
                'line-item': { data: { type: 'lesson', id: lesson1.id } },
                order: { data: { type: 'orders', id: order.id } }
              }
            }
          }

          expect { post('/api/order_line_items', params) }
            .to change(OrderLineItem, :count).by(0)

          expect(response.status).to eq 200

          oli.reload

          expect(oli.quantity).to eq(2)
        end
      end

      context 'when creating an order line item' do
        let(:params) { {
          payment_token: '123abc',
          data: {
            type: 'order-line-items',
            attributes: { quantity: 1 },
            relationships: {
              'line-item': { data: { type: 'lesson', id: lesson1.id } },
              order: { data: { type: 'orders', id: order.id } }
            }
          }
        } }

        it 'can add an item to the order' do
          expect { post '/api/order_line_items', params }
            .to change(OrderLineItem, :count).by 1

          expect(response.status).to eq 201
        end

        it 'does not allow price forgery' do
          params[:data][:attributes][:price] = 0.01
          post '/api/order_line_items', params

          result = json_api_data['attributes']['price'].to_f
          expect(result).to eq lesson1.current_price
        end

        it 'correctly adjusts the price with no prior items' do
          post '/api/order_line_items', params
          order.reload

          expect(order.order_line_items.length).to eq 1
          expect(order.sub_total).to eq lesson1.current_price
        end

        it 'correctly adjusts the price with a prior item' do
          some_item = create(:line_item, price: 12, host: organization)
          add_to_order!(order, some_item, price: 12)
          expect(order.order_line_items.length).to eq 1

          post '/api/order_line_items', params

          order.reload
          expect(order.order_line_items.length).to eq 2
          expect(order.sub_total).to eq lesson1.current_price + 12
        end

        it 'cannot receive a membership discount' do
          create(:membership_option, host: organization)
          create(:membership_discount, host: organization)

          # If a discount were received, this would be 2
          expect { post '/api/order_line_items', params }
            .to change(OrderLineItem, :count).by(1)

        end
      end
    end
  end

end
