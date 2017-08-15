# frozen_string_literal: true

require 'rails_helper'

describe Api::NotesController, type: :request do
  include RequestSpecUserSetup

  context 'not logged in' do
    it 'wants all notes' do
      get "/api/notes?host_id=#{organization.id}&host_type=#{organization.class.name}"
      expect(response.status).to eq 401
    end
  end

  context 'logged in' do
    [:owner, :organization_collaborator].each do |role|
      context role do
        before(:each) do
          @headers = auth_header_for(send(role))
        end

        context 'index' do
          it 'requires host id and type' do
            get '/api/notes', {}, @headers
            expect(response.status).to eq 400
          end

          it 'wants all notes' do
            get "/api/notes?host_id=#{organization.id}&host_type=#{organization.class.name}", {}, @headers
            expect(response.status).to eq 200
          end
        end

        context 'create' do
          let(:create_params) {
            jsonapi_params(
              'notes',
              attributes: { note: 'somethin' },
              relationships: { host: organization, target: stray_user }
            )
          }

          it 'succeeds' do
            post '/api/notes', create_params, @headers
            expect(response.status).to eq 201
          end

          it 'creates a note record' do
            expect {
              post '/api/notes', create_params, @headers
            }.to change(Note, :count).by 1
          end
        end

        context 'updates' do
          let(:note) { create(:note, host: organization, author: owner) }
          let(:update_params) {
            jsonapi_params('notes', id: note.id, attributes: { note: 'updated!!!!' })
          }

          it 'succeeds' do
            put "/api/notes/#{note.id}", update_params, @headers
            expect(response.status).to eq 200
          end

          it 'updates a note record' do
            put "/api/notes/#{note.id}", update_params, @headers
            expect(json_api_data['attributes']['note']).to eq 'updated!!!!'
          end
        end

        context 'destroy' do
          let!(:note) { create(:note, host: organization, author: owner) }

          it 'succeeds' do
            delete "/api/notes/#{note.id}", {}, @headers
            expect(response.status).to eq 200
          end

          it 'deletes the record' do
            expect {
              delete "/api/notes/#{note.id}", {}, @headers
            }.to change(Note, :count).by(-1)
          end
        end

        context 'show' do
          let(:note) { create(:note, host: organization, author: owner) }

          it 'succeeds' do
            get "/api/notes/#{note.id}", {}, @headers
            expect(response.status).to eq 200
          end
        end
      end
    end

    context 'is not a collaborator' do
      before(:each) do
        @headers = auth_header_for(stray_user)
      end

      context 'index' do
        it 'wants all notes' do
          create(:note, host: organization)
          get "/api/notes?host_id=#{organization.id}&host_type=#{organization.class.name}", {}, @headers
          expect(response.status).to eq 403
        end
      end

      context 'create' do
        let(:create_params) {
          jsonapi_params(
            'notes',
            attributes: { note: 'somethin' },
            relationships: { host: organization, target: stray_user }
          )
        }

        it 'is denied' do
          post '/api/notes', create_params, @headers
          expect(response.status).to eq 403
        end
      end

      context 'updates' do
        let(:note) { create(:note, host: organization, author: owner) }
        let(:update_params) {
          jsonapi_params('notes', id: note.id, attributes: { note: 'updated!!!!' })
        }

        it 'is denied' do
          put "/api/notes/#{note.id}", update_params, @headers
          expect(response.status).to eq 403
        end
      end

      context 'destroy' do
        let!(:note) { create(:note, host: organization, author: owner) }

        it 'in denied' do
          delete "/api/notes/#{note.id}", {}, @headers
          expect(response.status).to eq 403
        end
      end

      context 'show' do
        let(:note) { create(:note, host: organization, author: owner) }

        it 'is denied' do
          get "/api/notes/#{note.id}", {}, @headers
          expect(response.status).to eq 403
        end
      end
    end
  end
end
