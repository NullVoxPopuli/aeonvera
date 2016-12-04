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
    context 'manages an organization' do
      context 'index' do
        it 'requires host id and type' do
          get '/api/notes', {}, auth_header_for(owner)
          expect(response.status).to eq 400
        end

        it 'wants all notes' do
          get "/api/notes?host_id=#{organization.id}&host_type=#{organization.class.name}", {}, auth_header_for(owner)
          expect(response.status).to eq 200
        end
      end

      context 'create' do
        it 'succeeds' do
          post '/api/notes', create_params('notes'
            attributes
          )
        end
      end
    end

    context 'is a collaborator' do

    end

    context 'is not a collaborator' do

    end
  end
end
