# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::DiscountsController, type: :controller do
  before(:each) do
    @event = create(:event)
    login_through_api(@event.hosted_by)
  end

  context 'create' do
    it 'creates' do
      json_api = {
        data: {
          type: 'discounts',
          attributes: {
            code: 'supersecret',
            amount: '10.0',
            kind: Discount::DOLLARS_OFF,
            requires_student_id: true,
            allowed_number_of_uses: nil
          },
          relationships: {
            host: {
              data: {
                id: @event.id,
                type: 'events'
              }
            }
          }
        }
      }

      json_api_create_with(Discount, json_api)
    end
  end

  context 'update' do
    before(:each) do
      @discount = create(:discount, host: @event)
    end
    it 'updates' do
      json_api = {
        data: {
          type: 'discounts',
          id: @discount.id,
          attributes: {
            code: 'supersecret',
            amount: '10.0',
            kind: Discount::PERCENT_OFF,
            requires_student_id: !@discount.requires_student_id?,
            allowed_number_of_uses: 1
          }
        }
      }

      json_api_update_with(@discount, json_api)
    end
  end
end
