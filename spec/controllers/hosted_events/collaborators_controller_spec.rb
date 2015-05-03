require 'spec_helper'

describe Hosts::CollaboratorsController do
  render_views

  before(:each) do
    login
    @event = create(:event, hosted_by: @user)
  end

  context '#index' do
    it 'returns no collaborators, cause there are 0' do
      get :index, hosted_event_id: @event.id
      expect(assigns(:collaborators)).to be_empty
    end

    it 'has one collaborator' do
      user = create(:user)
      create(:collaboration, user: user, collaborated: @event)

      get :index, hosted_event_id: @event.id
      collaborators = assigns(:collaborators)

      expect(collaborators.size).to eq 1

      collaborator = collaborators.first
      expect(collaborator ).to eq user
    end
  end

  context '#new' do
    it 'it shold not error' do
      # this action doesn't do anything
      get :new, hosted_event_id: @event.id
    end
  end

  context '#edit' do
    it 'sets collaboration and user' do
      user = create(:user)
      create(:collaboration, user: user, collaborated: @event)

      get :edit, hosted_event_id: @event.id, id: user.id
      expect(assigns(:user)).to eq user
    end

    it 'is not authorized' do
      skip "permissions not implemented"
    end
  end

  context '#destroy' do
    it 'destroys a collaboration' do
      user = create(:user)
      create(:collaboration, user: user, collaborated: @event)

      expect{
        delete :destroy, hosted_event_id: @event.id, id: user.id
      }.to change(Collaboration, :count).by(-1)
    end

    it 'is not authorized' do
      skip "permissions not implemented"
    end
  end

  context '#update' do
    # what is there to update? collaborators don't have options?
    it 'redirects to the list of collaborators' do

    end

    it 'updates the collaboration' do

    end
  end

  context '#accept' do
    before(:each) do
      xhr :post, :invite, hosted_event_id: @event.id, email: "test@test.com"
    end

    it 'creates a collaboration' do
      user = create(:user, email: "test@test.com")
      #login_as(user, scope: :user)



    end


    it 'ensures that the email address matches the currently logged in user' do

    end


    it 'redirects to login if the user is not logged in' do

    end
  end

  context '#invite' do
    it 'stores the invite key in cache' do
      skip("Need to write a function to list available keys")
      xhr :post, :invite, hosted_event_id: @event.id, email: "test@test.com"
    end

    it 'sends an email' do
      ActionMailer::Base.deliveries.clear

      expect{
        xhr :post, :invite, hosted_event_id: @event.id, email: "test@test.com"
      }.to change(ActionMailer::Base.deliveries, :count).by(1)

    end

    it 'does not send an email if the user is already a collaborator' do
      user = create(:user)
      create(:collaboration, user: user, collaborated: @event)
      ActionMailer::Base.deliveries.clear

      expect{
        xhr :post, :invite, hosted_event_id: @event.id, email: user.email
      }.to change(ActionMailer::Base.deliveries, :count).by(0)

    end
  end

end
