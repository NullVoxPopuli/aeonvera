# frozen_string_literal: true
require 'rails_helper'

describe Api::CollaborationsController, type: :request do
  before(:each) do
    host! APPLICATION_CONFIG[:domain][Rails.env]
  end

  context 'events' do
    let(:event) { create(:event, hosted_by: create_confirmed_user) }
    let(:owner) { event.hosted_by }
    let(:admin) { create_confirmed_user }
    let(:collaborator) { create_confirmed_user }
    let(:host_params) { "host_id=#{event.id}&host_type=Event" }
    let(:set_login_header_as) do
      lambda do |user|
        @headers = { 'Authorization' => 'Bearer ' + user.authentication_token }
      end
    end

    context 'is not logged in' do
      context 'it should error for request:' do
        let(:collaboration) { create(:collaboration, collaborated: event, user: collaborator) }
        it 'create' do
          post '/api/collaborations', {}
          expect(response.status).to eq 401
        end

        it 'update' do
          put "/api/collaborations/#{collaboration.id}", {}
          expect(response.status).to eq 401
        end

        it 'destroy' do
          delete "/api/collaborations/#{collaboration.id}"
          expect(response.status).to eq 401
        end

        it 'reads - route does not exist' do
          get "/api/collaborations/#{collaboration.id}"
          expect(response.status).to eq 404
        end

        it 'reads all' do
          get '/api/collaborations?' + host_params
          expect(response.status).to eq 401
        end
      end
    end

    context 'is logged in' do
      context 'is owner' do
        before(:each) do
          set_login_header_as.call(owner)
        end

        context 'creating' do
          let(:params) do
            # TODO: use this in other places
            lambda do |attributes = {}, relationships = {}|
              {
                data: {
                  type: 'collaborations',
                  attributes: attributes,
                  relationships: relationships.each_with_object({}) do |(k, v), h|
                    h[k] = { data: { type: v.class.name.downcase.pluralize, id: v.id } }
                  end
                }
              }
            end
          end

          it 'can create' do
            create_params = params.call(
              email: collaborator.email, host_type: Event.name, host_id: event.id
            )

            post '/api/collaborations', create_params, @headers
            expect(response.status).to eq 201
          end

          it 'does not create a collaboration' do
            create_params = params.call(
              email: collaborator.email, host_type: Event.name, host_id: event.id
            )

            expect do
              post '/api/collaborations', create_params, @headers
            end.to change(Collaboration, :count).by 0
          end

          it 'sends an email invitation' do
            create_params = params.call(
              email: collaborator.email, host_type: Event.name, host_id: event.id
            )

            expect do
              post '/api/collaborations', create_params, @headers
            end.to change(ActionMailer::Base.deliveries, :count).by 1
          end
        end

        context 'on existing' do
          let!(:collaboration) { create(:collaboration, collaborated: event, user: collaborator) }
          let(:params) do
            lambda do |attributes|
              {
                data: {
                  type: 'collaborations',
                  id: collaboration.id,
                  attributes: attributes
                }
              }
            end
          end

          it 'can update' do
            put "/api/collaborations/#{collaboration.id}", params.call(permissions: 1), @headers

            expect(response.status).to eq 200
          end

          it 'can destroy' do
            delete "/api/collaborations/#{collaboration.id}", {}, @headers
            expect(response.status).to eq 200
          end

          it 'destroys' do
            expect do
              delete "/api/collaborations/#{collaboration.id}", {}, @headers
            end.to change(Collaboration, :count).by(-1)
          end

          it 'can read all' do
            get '/api/collaborations?' + host_params, {}, @headers
            expect(response.status).to eq 200
          end

          context 'scope' do
            before(:each) do
              create_list(
                :collaboration, 5,
                collaborated: create(:event),
                user: create(:user)
              )
            end

            it 'is scoped to the event' do
              get '/api/collaborations?' + host_params, {}, @headers
              expect(json_api_data.length).to eq 1
            end
          end
        end
      end

      context 'is admin' do
        before(:each) do
          set_login_header_as.call(admin)
        end
      end

      context 'is collaborator' do
        before(:each) do
          event.collaborators << collaborator
          event.save
          set_login_header_as.call(collaborator)
        end

        it 'cannot create' do
          create_params = {
            data: {
              type: 'collaborations',
              attributes: {
                email: collaborator.email,
                host_type: Event.name,
                host_id: event.id
              }
            }
          }

          post '/api/collaborations', create_params, @headers
          expect(response.status).to eq 404
        end

        context 'on existing' do
          let(:collaboration) { create(:collaboration, collaborated: event, user: collaborator) }
          let(:fake_json_api) {
            {
              data: {
                type: 'collaborations',
                id: collaboration.id,
                attributes: {}
              }
            }
          }

          it 'cannot update' do
            put "/api/collaborations/#{collaboration.id}", fake_json_api, @headers
            expect(response.status).to eq 403
          end

          it 'cannot destroy' do
            delete "/api/collaborations/#{collaboration.id}", @headers
            expect(response.status).to eq 401
          end

          it 'can read all' do
            get '/api/collaborations?' + host_params, {}, @headers
            expect(response.status).to eq 200
          end
        end
      end

      context 'is non collaborator' do
        before(:each) do
          set_login_header_as.call(create_confirmed_user)
        end

        it 'cannot create' do
          create_params = {
            data: {
              type: 'collaborations',
              attributes: {
                email: collaborator.email,
                host_type: Event.name,
                host_id: event.id
              }
            }
          }

          post '/api/collaborations', create_params, @headers
          expect(response.status).to eq 404
        end

        context 'on existing' do
          let(:collaboration) { create(:collaboration, collaborated: event, user: collaborator) }
          let(:fake_json_api) {
            {
              data: {
                type: 'collaborations',
                id: collaboration.id,
                attributes: {}
              }
            }
          }

          it 'cannot update' do
            put "/api/collaborations/#{collaboration.id}", fake_json_api, @headers

            expect(response.status).to eq 403
          end

          it 'cannot destroy' do
            delete "/api/collaborations/#{collaboration.id}", @headers
            expect(response.status).to eq 401
          end

          it 'cannot read all' do
            get '/api/collaborations?' + host_params, {}, @headers
            expect(response.status).to eq 403
          end
        end
      end
    end
  end
end
