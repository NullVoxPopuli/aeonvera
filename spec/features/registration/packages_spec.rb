require 'spec_helper'


describe 'Registration Package Configuration' do

  before(:each) do
    login_as_confirmed_user
    Event.destroy_all
    @event = create(:event, hosted_by: @user)
    @opening_tier = @event.opening_tier
    @opening_tier.date = Time.now - 1.day
    @opening_tier.save
  end


  context 'package configurations' do
    before(:each) do
      @package = create(:package, event: @event)
    end

    it 'package is selectable packages to be clickable' do
      visit @event.url

      expect{
        selects_package
      }.to_not raise_error
    end

    it 'does not allow an expired package' do
      @package.update!(expires_at: 2.days.ago)
      visit @event.url

      expect(page).to_not have_selector("input#attendance_package_id_#{@package.id}")
    end

    it 'does not allow a package with an attendee limit' do
      @package.update!(attendee_limit: 0)
      visit @event.url
      expect(page).to_not have_selector("input#attendance_package_id_#{@package.id}")
    end
  end

  context 'package price is 0' do
    before(:each) do
      @package = create(:package, event: @event, initial_price: 0, at_the_door_price: 0)
      @friday_dance = create(:line_item, event: @event, price: 25)
    end

    it 'totals the line item - package has no effect' do
      visit @event.url
      selects_package
      selects_orientation
      provides_address

      selects_line_item(@friday_dance)

      submit_form

      expect(page).to_not have_content("Paid")
      expect(page).to_not have_content("Paid $0.00")
    end
  end



end
