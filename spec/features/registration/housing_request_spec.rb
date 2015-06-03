require 'spec_helper'

describe 'Registration' do

  before(:each) do
    login_as_confirmed_user
    Event.destroy_all
    @event = create(:event, hosted_by: @user)
    @opening_tier = @event.opening_tier
    @opening_tier.date = Time.now - 1.day
    @opening_tier.save
    @package = create(:package, event: @event)


    visit @event.url
    # fill out all the stuff we don't care about at the moment
    selects_orientation
    selects_package
    provides_address
  end

  context 'Requesting Housing' do

    it 'does not request housing' do
      submit_form

      expect(page).to_not have_content("Housing Request")
    end

    it 'requests housing' do
      check('attendance_needs_housing')
      submit_form

      expect(page).to_not have_content("Housing Request")

    end

    it 'requires a phone number' do

    end

  end

end
