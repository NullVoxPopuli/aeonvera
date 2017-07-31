# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::CustomFieldsController, type: :controller do
  before(:each) do
    @event = create(:event)
    login_through_api(@event.hosted_by)
  end

  context 'create' do
    it 'creates' do
      json_api = {
        data: {
          type: 'custom-fields',
          attributes: {
            label: 'a field!',
            default_value: 'some text',
            kind: 1,
            editable: true
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

      json_api_create_with(CustomField, json_api)
    end
  end

  context 'update' do
    before(:each) do
      @custom_field = create(:custom_field, host: @event)
    end
    it 'updates' do
      json_api = {
        data: {
          type: 'custom-fields',
          id: @custom_field.id,
          attributes: {
            label: @custom_field.label + '- changed',
            default_value: (@custom_field.default_value || '') + ' some text',
            kind: @custom_field.kind + 1,
            editable: !@custom_field.editable?
          }
        }
      }

      json_api_update_with(@custom_field, json_api)
    end
  end
end
