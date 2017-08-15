# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::LessonsController, type: :controller do
  before(:each) do
    @organization = create(:organization, owner: create_confirmed_user)
  end

  context 'lesson already exists' do
    before(:each) do
      @lesson = create(:lesson)
    end

    describe 'index' do
      it 'uses the lessons Serializer' do
        get :index, organization_id: @organization.id

        # data = json_api_data
        # attributes = data['attributes']
        # expect(controller).to use_serializer(LineItem::LessonSerializer)
      end
    end

    describe 'show' do
      before(:each) do
        login_through_api(@organization.owner)
      end

      it 'uses the lessons serializer' do
        get :show, id: @lesson.id
        expect(response.status).to eq 200
      end
    end
  end

  describe 'update' do
    before(:each) do
      login_through_api(@organization.owner)
      @lesson = create(:lesson, host: @organization)
    end

    it 'updates a lesson' do
      json_api = {
        data: {
          type: 'lessons',
          attributes: {
            price: '23.56',
            description: 'wuuuut',
            name: @lesson.name + ' new lindyhop'
          }
        }
      }

      json_api_update_with(@lesson, json_api)
    end
  end

  describe 'create' do
    before(:each) do
      login_through_api(@organization.owner)
    end

    it 'creates a new lesson' do
      json_api = {
        data: {
          type: 'lessons',
          attributes: {
            price: '9.0',
            name: 'new lindyhop',
            description: 'aoeuuu'
          },
          relationships: {
            host: {
              data: {
                id: @organization.id,
                type: 'organizations'
              }
            }
          }
        }
      }

      json_api_create_with(LineItem::Lesson, json_api)
    end
  end
end
