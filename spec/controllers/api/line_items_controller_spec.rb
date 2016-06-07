require 'rails_helper'

RSpec.describe Api::LineItemsController, type: :controller do
  let(:user)  { create_confirmed_user }
  let(:event) { create(:event, hosted_by: user) }
  before(:each) do
    login_through_api
  end

  context 'create' do
    it 'creates a new line litem' do
      json_api = {
        data: {
          type: 'line-items',
          attributes: {
            name: 'Some item',
            price: '10.0',
            description: 'A bag or a shoe',
            # expires_at: Time.now,
            # starts_at: Time.now,
            # ends_at: Time.now,
            # becomes_available_at: Time.now,
            # registration_opens_at: Time.now,
            # registration_closes_at: Time.now
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

      json_api_create_with(LineItem, json_api)
    end
  end

  context 'update' do
    before(:each) do
      @line_item = create(
        :line_item,
        host: event)
    end

    it 'updates a line item' do
      json_api = {
        data: {
          id: @line_item.id,
          type: 'housing-provisions',
          attributes: {
            name: 'Some item',
            price: '15.0',
            description: 'A bag or a shoe',
            # expires_at: Time.now.iso8601(3),
            # starts_at: Time.now.iso8601(3),
            # ends_at: Time.now.iso8601(3),
            # becomes_available_at: Time.now.iso8601(3),
            # registration_opens_at: Time.now.iso8601(3),
            # registration_closes_at: Time.now.iso8601(3)
          }
        }
      }

      json_api_update_with(@line_item, json_api)
    end
  end
end
