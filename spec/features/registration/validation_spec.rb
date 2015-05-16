require 'spec_helper'


describe 'Registration Validation' do

  before(:each) do
    login_as_confirmed_user
    Event.destroy_all
    @event = create(:event, hosted_by: @user)
    @opening_tier = @event.opening_tier
    @opening_tier.date = Time.now - 1.day
    @opening_tier.save
  end

  context 'validation errors' do
    before(:each) do
      @opening_tier.date = Time.now - 10.day
      @opening_tier.save
    end

    it 'requires a package to be selected' do
      visit @event.url
      submit_form
      expect(page).to have_content("Package can't be blank")
    end

    it 'requires a track / level to be selected for a particular package' do
      package = create(:package, event: @event, requires_track: true)
      visit @event.url

      package_id = "#attendance_package_id_#{package.id}"
      check_box_with_id package_id
      submit_form
      expect(page).to have_content("Level can't be blank")
    end

    it 'requires address information' do
      visit @event.url
      submit_form
      expect(page).to have_content("Address must have a city")
      expect(page).to have_content("Address must have a state")
      expect(page).to have_content("Address must have a zip code")
    end

    it 'requires a dance orientation' do
      visit @event.url
      submit_form
      expect(page).to have_content("Dance orientation can't be blank")
    end

    it 'requires a phone number when volunteering' do
      visit @event.url
      is_volunteering
      submit_form
      expect(page).to have_content("Phone number must be present when volunteering")
    end

    it 'does not require a phone number' do
      visit @event.url
      submit_form
      expect(page).to_not have_content("Phone number must be present when volunteering")
    end

  end



end
