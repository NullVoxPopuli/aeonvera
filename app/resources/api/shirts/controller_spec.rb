# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::ShirtsController, type: :controller do
  context 'not logged in' do
  end

  context 'logged in and is a collaborator' do
  end

  context 'logged in and the owner of the event' do
    let(:user)  { create_confirmed_user }
    let(:event) { create(:event, hosted_by: user) }
    before(:each) do
      login_through_api(event.hosted_by)
    end

    context 'index' do
    end

    context 'show' do
    end

    context 'update' do
      before(:each) do
        @shirt = create(:shirt, host: event)
      end

      it 'updates an existing shirt' do
        json_api = {
          data: {
            type: 'shirts',
            attributes: {
              name: 'Some shirt',
              price: '15.0',
              description: 'for people to wear',
              sizes: [
                {
                  'id' => 'L', # cause serializer renders this for ember
                  'size' => 'L',
                  'price' => '15.0',
                  'inventory' => 4,
                  'purchased' => 0,
                  'remaining' => 4
                },
                {
                  'id' => 'M',
                  'size' => 'M',
                  'price' => '10.0',
                  'inventory' => 6,
                  'purchased' => 0,
                  'remaining' => 6
                }
              ]
            }
          }
        }

        json_api_update_with(@shirt, json_api)
      end
    end

    context 'create' do
      it 'creates a new shirt' do
        json_api = {
          data: {
            type: 'shirts',
            attributes: {
              name: 'Some shirt',
              price: '15.0',
              description: 'for people to wear',
              sizes: [
                {
                  'id' => 'L', # cause serializer renders this for ember
                  'size' => 'L',
                  'price' => '15.0',
                  'inventory' => 4,
                  'purchased' => 0,
                  'remaining' => 4
                },
                {
                  'id' => 'M',
                  'size' => 'M',
                  'price' => '10.0',
                  'inventory' => 9,
                  'purchased' => 0,
                  'remaining' => 9
                }
              ]
            },
            relationships: {
              host: {
                data: {
                  id: event.id,
                  type: 'events'
                }
              }
            }
          }
        }

        json_api_create_with(LineItem::Shirt, json_api)
      end
    end
  end
end
