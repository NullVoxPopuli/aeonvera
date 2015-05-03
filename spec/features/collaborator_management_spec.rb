require 'spec_helper'

describe "Collaboration Management", js: true  do

  before(:each) do
    login_as_confirmed_user
    @event = create(:event, hosted_by: @user)
    @organization = create(:organization, hosted_by: @user)

  end

  context 'an invite exists' do


    it 'only applies to the event' do
      visit hosted_event_collaborators_path(@event)

      fill_in "email", with: "otheruser@something.com"
    end

    it 'only applies to the organization' do
      visit organization_collaborators_path(@organization)

      fill_in "email", with: "otheruser@something.com"
    end

  end

  context 'an invite is sent' do
    it 'creates an email' do
      ActionMailer::Base.deliveries.clear
      visit hosted_event_collaborators_path(@event)
      fill_in "email", with: "otheruser@something.com"

      expect{
        submit_form

        # have to call this so that capybara waits for a response
        expect(page).to have_content("invited")
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'tells the inviter what happened' do
      visit hosted_event_collaborators_path(@event)
      fill_in "email", with: "otheruser@something.com"
      submit_form

      expect(page).to have_content("After they have accepted the invitation")
    end

    it 'clears the email field' do
      visit hosted_event_collaborators_path(@event)
      fill_in "email", with: "otheruser@something.com"

      submit_form
      expect(page).to have_field('email', with: '')
    end
  end

  context 'an invite is accepted' do
    before(:each) do
      ActionMailer::Base.deliveries.clear

      # create an invite
      visit hosted_event_collaborators_path(@event)
      fill_in "email", with: "otheruser@something.com"
      submit_form

      @invite_email = ActionMailer::Base.deliveries.first
    end

    it 'displays a welcome message' do

    end


    it 'displays a welcome message once logged in' do

    end

    it 'says that the user is not the intended recipient (email mismatch)' do

    end
  end

end
