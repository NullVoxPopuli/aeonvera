require 'rails_helper'

describe Api::Users::RegistrationsController, type: :request do

  context 'not logged in' do
    it_behaves_like(
      'unauthorized',
      factory: :registration,
      base_path: '/api/users/registrations'
    )
  end

  context 'logged in' do
    let(:event) { create(:event) }
    let(:user) { create_confirmed_user }
  end
end
