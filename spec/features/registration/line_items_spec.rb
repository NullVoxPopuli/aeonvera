require 'spec_helper'


describe 'Registration Line Items' do

  before(:each) do
    login_as_confirmed_user
    Event.destroy_all
    @event = create(:event, hosted_by: @user)
    @opening_tier = @event.opening_tier
    @opening_tier.date = Time.now - 1.day
    @opening_tier.save
  end

  describe 'expiration' do

    it 'has expired' do
      item = create(:line_item, event: @event, expires_at: 2.days.ago)

      visit @event.url

      expect(page).to_not have_content(item.name)
    end

    it 'has not expired' do
      item = create(:line_item, event: @event, expires_at: 2.days.from_now)

      visit @event.url

      expect(page).to have_content(item.name)
    end

  end


  describe 'becoming available' do

    it 'is available' do
        item = create(:line_item, event: @event, becomes_available_at: 2.days.ago)

        visit @event.url

        expect(page).to have_content(item.name)
    end

    it 'is not yet available' do
        item = create(:line_item, event: @event, becomes_available_at: 2.days.from_now)
        visit @event.url

        expect(page).to_not have_content(item.name)
    end

  end


end
