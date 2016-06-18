require 'rails_helper'

describe Api::SponsorshipsController, type: :request do
  let(:path) { '/api/sponsorships/' }
  let(:path_with) { ->(id) { path + id.to_s } }
  let(:new_sponsorship) {
    lambda do |user = nil|
      e = create(:event, hosted_by: user || create(:user))
      create(:sponsorship, sponsored: e, discount: create(:discount, host: e))
    end
  }
  before(:each) do
    host! APPLICATION_CONFIG[:domain][Rails.env]
  end

  context 'is not logged in' do
    it 'can view index' do
      get path
      # this is not private data
      expect(response.status).to eq 200
    end

    it 'cannot create' do
      post path, {}
      expect(response.status).to eq 401
    end

    it 'cannot update' do
      sponsorship = new_sponsorship.call
      patch path + sponsorship.id.to_s
      expect(response.status).to eq 401
    end

    it 'cannot destroy' do
      sponsorship = new_sponsorship.call
      delete path + sponsorship.id.to_s
      expect(response.status).to eq 401
    end
  end

  context 'is logged in' do
    let(:user) { create_confirmed_user }
    let(:event) { create(:event, hosted_by: user) }
    let(:organization) { create(:organization) }
    let(:discount) { create(:discount, host: event) }
    before(:each) do
      @headers = {
        'Authorization' => 'Bearer ' + user.authentication_token
      }
    end

    context 'create' do
      it 'creates' do
        params = {
          data: {
            attributes: {
              'sponsor-id': organization.id,
              'sponsor-type': 'organizations',
              'sponsored-id': event.id,
              'sponsored-type': 'events',
              'discount-id': discount.id,
              'discount-type': 'discounts'
            }
          }
        }

        expect {
          post path, params, @headers
          expect(response.status).to eq 201
        }.to change(Sponsorship, :count).by(1)
      end
    end

    context 'object exists' do
      let!(:sponsorship) { new_sponsorship.call(user) }

      context 'update' do
        it 'updates' do
          params = {
            data: {
              id: sponsorship.id,
              attributes: {
                id: sponsorship.id,
                'sponsor-id': organization.id,
                'sponsor-type': 'organizations',
                'sponsored-id': event.id,
                'sponsored-type': 'events',
                'discount-id': discount.id,
                'discount-type': 'discounts'
              }
            }
          }

          put path_with.(sponsorship.id), params, @headers
          expect(response.status).to eq 200

          s = Sponsorship.find(sponsorship.id)
          expect(s.sponsor).to eq organization
          expect(s.sponsored).to eq event
        end
      end

      context 'destroy' do
        it 'destroys' do
          expect {
            delete path_with.(sponsorship.id), {}, @headers
            expect(response.status).to eq 200
          }.to change(Sponsorship, :count).by(-1)
        end
      end
    end
  end
end
