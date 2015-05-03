require 'spec_helper'

describe "At the door registration" do

  before(:each) do
    login_as_confirmed_user
    Event.destroy_all
    @event = create(:event, hosted_by: @user, starts_at: 2.hours.ago)
    @opening_tier = @event.opening_tier
    @opening_tier.date = Time.now - 1.day
    @opening_tier.save
  end

  context 'field validation' do
    it 'requires a package' do
      visit new_hosted_event_attendance_path(hosted_event_id: @event.id)
      submit_form
      expect(page).to have_content("Package can't be blank")
    end

    it 'requires a track / level to be seleceted for a particular package' do
      package = create(:package, event: @event, requires_track: true)
      visit new_hosted_event_attendance_path(hosted_event_id: @event.id)

      package_id = "#attendance_package_id_#{package.id}"
      check_box_with_id package_id
      submit_form
      expect(page).to have_content("Level can't be blank")
    end

    it 'requires a dance orientation' do
      visit new_hosted_event_attendance_path(hosted_event_id: @event.id)
      selects_orientation
      submit_form
      expect(page).to_not have_content("Dance orientation can't be blank")
    end

    context 'creates a user' do
      before(:each) do
        @package = create(:package, event: @event)
        visit new_hosted_event_attendance_path(hosted_event_id: @event.id)
        fills_in_name
        @email = fills_in_email
        selects_package(@event.packages.first)
        selects_orientation
      end

      it 'providing an email creates a user' do
        expect{
          submit_form

          expect(page).to_not have_content("errors prohibited this event from being saved")
        }.to change(User, :count).by(1)
      end

      it 'has the same email as on the form' do
        submit_form
        expect(page).to_not have_content("errors prohibited this event from being saved")

        expect(User.last.email).to eq @email
      end

      it 'is sent a confirmation email for later' do
        ActionMailer::Base.deliveries.clear

        submit_form
        expect(page).to_not have_content("errors prohibited this event from being saved")

        emails = ActionMailer::Base.deliveries
        expect(emails.length).to eq 1
        expect(emails.first.subject).to include("Confirm")
        expect(emails.first.to).to include(@email)
      end
    end

    context 'email is not provided' do
      before(:each) do
        @package = create(:package, event: @event)
        visit new_hosted_event_attendance_path(hosted_event_id: @event.id)
        @name = fills_in_name
        selects_package(@event.packages.first)
        selects_orientation
      end

      it 'creates attendance with the persons name' do
        submit_form
        expect(Attendance.last.attendee_name).to eq @name
      end

      it 'does not create a user' do
        expect{
          submit_form

          expect(page).to_not have_content("errors prohibited this event from being saved")
        }.to change(User, :count).by(0)
      end
    end

    context 'name' do
      it 'requires a name' do
        visit new_hosted_event_attendance_path(hosted_event_id: @event.id)
        submit_form

        expect(page).to have_content("First name must be present")
        expect(page).to have_content("Last name must be present")
      end

      it 'does not require a name when filled in' do
        visit new_hosted_event_attendance_path(hosted_event_id: @event.id)
        fills_in_name
        submit_form

        expect(page).to_not have_content("First name must be present")
        expect(page).to_not have_content("Last name must be present")
      end
    end

    it 'does not require address' do
      visit new_hosted_event_attendance_path(hosted_event_id: @event.id)
      submit_form

      expect(page).to_not have_content("Address must have a city")
      expect(page).to_not have_content("Address must have a state")
      expect(page).to_not have_content("Address must have a zip code")
    end

    it 'does not require a phone number' do
      visit new_hosted_event_attendance_path(hosted_event_id: @event.id)
      submit_form
      expect(page).to_not have_content("Phone number must be present when volunteering")
    end


  end
end
