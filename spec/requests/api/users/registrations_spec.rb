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

    context 'index' do
      it 'lists registrations' do

      end
    end

    context 'show' do
      it 'retrieves a registration' do

      end
    end

    context 'create' do
      it 'creates a registration' do

      end
    end

    context 'update' do
      it 'updates a registration' do

      end
    end

    context 'destroy' do
      it 'deletes a registration' do

      end
    end
  end
end
