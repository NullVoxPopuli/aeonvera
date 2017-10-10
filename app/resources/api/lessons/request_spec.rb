# frozen_string_literal: true

require 'rails_helper'

describe Api::LessonsController, type: :request do
  include RequestSpecUserSetup

  context 'is not logged in' do
    it 'can not create' do
      post '/api/lessons', {}
      expect(response.status).to eq 401
    end

    context 'data exists' do
      let(:lesson) { create(:lesson, host: organization) }

      it 'can read all' do
        get "/api/lessons?organization_id=#{organization.id}"
        expect(response.status).to eq 200
      end

      it 'can read' do
        get "/api/lessons/#{lesson.id}"
        expect(response.status).to eq 200
      end

      it 'can not delete' do
        delete "/api/lessons/#{lesson.id}"
        expect(response.status).to eq 401
      end

      it 'can not update' do
        put "/api/lessons/#{lesson.id}", {}
        expect(response.status).to eq 401
      end
    end
  end

  context 'is logged in' do
    # for each permission set (owner, collaborator, admin)
    context 'for each permission set' do
      # users = [owner, collaborator, admin]

      context 'is owner' do
        before(:each) do
          set_login_header_as.call(owner)
        end

        context 'creating' do
          it 'can create' do
            create_params = jsonapi_params('lessons',
                                           attributes: { name: 'hi', price: '2' },
                                           relationships: { host: organization })

            post '/api/lessons', create_params, @headers
            expect(response.status).to eq 201
          end

          it 'creates a lesson' do
            create_params = jsonapi_params('lessons',
                                           attributes: { name: 'hi', price: '2' },
                                           relationships: { host: organization })

            expect do
              post '/api/lessons', create_params, @headers
            end.to change(LineItem::Lesson, :count).by 1
          end
        end

        context 'on existing' do
          let!(:lesson) { create(:lesson, host: organization) }

          it 'can update' do
            put "/api/lessons/#{lesson.id}",
                jsonapi_params('lessons', id: lesson.id, attributes: { name: 'hi' }),
                @headers

            expect(response.status).to eq 200
          end

          it 'can destroy' do
            delete "/api/lessons/#{lesson.id}", {}, @headers
            expect(response.status).to eq 200
          end

          it 'destroys' do
            expect do
              delete "/api/lessons/#{lesson.id}", {}, @headers
            end.to change(LineItem::Lesson, :count).by(-1)
          end

          it 'can read all' do
            get "/api/lessons?organization_id=#{organization.id}", {}, @headers
            expect(response.status).to eq 200
          end
        end
      end
    end

    context 'is non collaborator' do
      before(:each) do
        set_login_header_as.call(create_confirmed_user)
      end

      it 'can not create' do
        create_params = {
          data: {
            type: 'lessons',
            attributes: {
              name: 'Yoga',
              price: '10',
              host_type: Organization.name,
              host_id: organization.id
            }
          }
        }

        post '/api/lessons', create_params, @headers
        expect(response.status).to eq 403
      end

      context 'data exists' do
        let(:lesson) { create(:lesson, host: organization) }
        let(:fake_json_api) do
          {
            data: {
              type: 'lessons',
              id: lesson.id,
              attributes: {}
            }
          }
        end

        it 'can read all' do
          get "/api/lessons?organization_id=#{organization.id}", {}, @headers
          expect(response.status).to eq 200
        end

        it 'can read' do
          get "/api/lessons/#{lesson.id}", {}, @headers
          expect(response.status).to eq 200
        end

        it 'can not delete' do
          delete "/api/lessons/#{lesson.id}", {}, @headers
          expect(response.status).to eq 403
        end

        it 'can not update' do
          put "/api/lessons/#{lesson.id}", fake_json_api, @headers
          expect(response.status).to eq 403
        end
      end
    end
  end
end
