require 'spec_helper'

describe HostedEventsController do

  context 'redirects on' do
    let(:event){ create(:event) }

    before(:each) do
      @user = event.user
      login(@user)
    end

    after(:each) do
      expect(flash[:alert]).to eq I18n.t('errors.not_authorized')
    end

    context 'edit' do
      before(:each) do
        allow(@user).to receive(:can_edit?){ false }
        allow(controller).to receive(:current_user){ @user }
      end

      it 'to show' do
        get :edit, id: event.id
        expected = { action: :show, id: event.id }
        expect(response).to redirect_to expected
      end

      context 'and update' do
        it 'to show' do
          put :update, id: event.id, event: {}
          expected = { action: :show, id: event.id }
          expect(response).to redirect_to expected
        end
      end

    end

    context 'create' do
      before(:each) do
        allow(@user).to receive(:can_create_event?){ false }
        allow(controller).to receive(:current_user){ @user }
      end

      it 'to index' do
        post :create, event: {}
        expect(response).to redirect_to action: :index
      end

      context 'and new' do
        it 'to index' do
          get :new
          expect(response).to redirect_to action: :index
        end
      end

    end

    context 'destroy' do
      before(:each) do
        allow(@user).to receive(:can_destroy?).and_return(false)
        allow(controller).to receive(:current_user){ @user }
      end

      it 'to show' do
        delete :destroy, id: event.id
        expect(response).to redirect_to action: :show
      end
    end

  end

end
