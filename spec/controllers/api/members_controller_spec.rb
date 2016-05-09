require 'rails_helper'

describe Api::MembersController, type: :controller do

  describe 'index' do

    context 'searching for a user' do
      it 'searches for a user' do
        login_through_api(create(:user))
        get :index, q: { first_name_eq: 'something' }
        expect(response.status).to eq 200
      end
    end

    context 'requires logged in' do
      it 'searches for a user' do
        get :index, q: { first_name_eq: 'something' }
        expect(response.status).to eq 401
      end
    end

  end
end
