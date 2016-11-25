require 'rails_helper'

describe Api::RestraintsController, type: :request do
  include RequestSpecUserSetup

  before(:each) do
    host! APPLICATION_CONFIG[:domain][Rails.env]
  end


  context 'is not logged in' do
    it 'cannot create' do
      post '/api/restraints', {}
      expect(response.status).to eq 401
    end

    context 'data exists' do
      let(:restraint) { create(:restraint) }

      it 'cannot index' do
        get '/api/restraints'
        expect(response.status).to eq 401
      end

      it 'cannot update' do
        put "/api/restraints/#{restraint.id}"
        expect(response.status).to eq 401
      end

      it 'cannot destroy' do
        delete "/api/restraints/#{restraint.id}"
        expect(response.status).to eq 401
      end
    end
  end

  context 'is logged in' do
    let(:package) { create(:package, event: event) }
    let(:discount) { create(:discount, event: event) }

    context 'is owner' do
      before(:each) do
        set_login_header_as.call(owner)
      end

      context 'creating' do
        it 'can create' do
          create_params = jsonapi_params(
            'restraints',
            relationships: {
              restricted_to: package,
              restriction_for: discount
            }
          )

          expect {
            post '/api/restraints', create_params, @headers
            expect(response.status).to eq 200
          }.to change(Restraint, :count).by 1
        end
      end
    end

    context 'is collaborator' do
      before(:each) do
        set_login_header_as.call(event_collaborator)
      end

      it 'can create' do
        create_params = jsonapi_params(
          'restraints',
          relationships: {
            restricted_to: package,
            restriction_for: discount
          }
        )

        expect {
          post '/api/restraints', create_params, @headers
          expect(response.status).to eq 200
        }.to change(Restraint, :count).by 1
      end
    end

    context 'is non collaborator' do
      before(:each) do
        set_login_header_as.call(stray_user)
      end

      context 'creating' do
        it 'cannot create' do
          create_params = jsonapi_params(
            'restraints',
            relationships: {
              restricted_to: package,
              restriction_for: discount
            }
          )

          expect {
            post '/api/restraints', create_params, @headers
            expect(response.status).to eq 404
          }.to change(Restraint, :count).by 0
        end

        it 'cannot update' do
          r = create(:restraint, dependable: package, restrictable: discount)

          update_params = jsonapi_params(
            'restraints',
            id: r.id,
            relationships: {
              restricted_to: nil,
              restriction_for: nil
            }
          )

          put "/api/restraints/#{r.id}", update_params, @headers
          expect(response.status).to eq 422
        end
      end
    end
  end
end
