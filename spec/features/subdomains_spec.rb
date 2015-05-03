require 'spec_helper'


describe 'Subdomains' do

  it 'attempts to access an invalid domain' do
    visit test_event_domain
    expect(page.current_url).to include(root_test_domain)
  end

  context 'dynamically defined subdomains' do

    before(:each) do
      @user = create(:user)
    end

    context 'events' do
      before(:each) do
        Event.destroy_all
      end

      it 'attempts to access event domain' do
        @event = create(:event, hosted_by: @user)

        visit @event.url
        expect(page).to have_content(@event.name)
      end

      it 'after an event is over, the subdomain should be available' do
        @event = create(:event, hosted_by: @user, ends_at: 2.days.ago, name: "not here")

        visit @event.url
        expect(page).to_not have_content(@event.name)
      end

      it 'navigates to a more recent event when the previous event with the same domain is over' do
        event = create(:event, domain: 'my', name: "hidden", hosted_by: @user, starts_at: 4.days.ago, ends_at: 2.days.ago)
        @event = create(:event, domain: 'my', name: "newer!", domain: event.domain, hosted_by: @user)

        expect(event.url).to eq @event.url

        visit @event.url
        expect(page).to have_content(@event.name)
      end

    end

    it 'attempts to access organization domain' do
      Organization.destroy_all
      @organization = create(:organization, owner: @user, domain: 'testevent')
      visit @organization.url
      expect(page).to have_content(@organization.name)
    end
  end

  context 'special domains' do

  end
end
