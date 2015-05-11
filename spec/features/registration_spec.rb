require 'spec_helper'


describe 'Registration' do

  before(:each) do
    login_as_confirmed_user
    Event.destroy_all
    @event = create(:event, hosted_by: @user)
    @opening_tier = @event.opening_tier
    @opening_tier.date = Time.now - 1.day
    @opening_tier.save
  end

  context 'custom fields' do
    before(:each) do
      @package = create(:package, event: @event)

      @custom1 = create(:custom_field, host: @event, user: @user)
      @custom2 = create(:custom_field, label: 'value 2', host: @event, user: @user, default_value: '2')
      @custom1_id = "#custom_fields_#{@custom1.id}"
      @custom2_id = "#custom_fields_#{@custom2.id}"
      @custom1_name = "custom_fields[#{@custom1.id}]"
      @custom2_name = "custom_fields[#{@custom2.id}]"
    end

    it 'renders the custom_fields on the form' do
      visit @event.url
      expect(page).to have_selector(@custom1_id)
      expect(page).to have_selector(@custom2_id)
    end

    it 'fills out the custom_fields, creating CustomFieldResponses' do
      visit @event.url
      selects_orientation
      selects_package
      provides_address

      fill_in @custom1_name, with: "value 1"

      expect{
        submit_form
        expect(page).to_not have_content("error")
      }.to change(CustomFieldResponse, :count).by(2)
    end
  end

  context 'payments' do
    before(:each) do
      allow_any_instance_of(Event).to receive(:has_payment_processor?){ true }
      allow_any_instance_of(StripeHelper).to receive(:stripe_checkout_script){ "" }
    end

    context 'payment was cash, then event enables only electronic payments' do

    end

    context 'payment method switching' do
      it 'has the payment method switcher' do
        @event.update!(accept_only_electronic_payments: false)
        registers_for_event

        expect(page).to have_selector(:link_or_button, 'Change Payment Method')
      end
    end

    it 'does not allow payment method switching' do
      @event.update!(accept_only_electronic_payments: true)
      registers_for_event
      expect(Order.last.payment_method).to eq Payable::Methods::STRIPE
      expect(page).to_not have_content("Change Payment Method")
    end

    it 'stripe is the only payment method' do
      @event.update!(accept_only_electronic_payments: true)

      registers_for_event

      expect(Order.last.payment_method).to eq Payable::Methods::STRIPE

      expect(page).to have_content("What is Stripe?")
      expect(page).to have_content("Paying with: Stripe")
    end
  end

  context 'receives registration email' do
    it 'sends a thank you email' do
      ActionMailer::Base.deliveries.clear

      registers_for_event
      emails = ActionMailer::Base.deliveries
      expect(emails.length).to eq 1
      expect(emails.first.subject).to include(@event.name)
      expect(emails.first.subject).to include("registering")
    end
  end

  context 'navigates away from the registration page' do

    it 'removes the subdomain' do
      visit @event.url
      first(:link, "Attended Events").click
      expect(current_url).to_not include(@event.subdomain)
    end
  end

  context 'domain change' do

    it 'visits an old event URL' do
      old_url = @event.url
      @event.domain = 'edited'
      @event.save

      visit old_url
      expect(page).to have_content('Domain not found')
    end

  end

  context 'user is not logged in' do
    before(:each) do
      logout(:user)
    end

    it 'tells the user they need to login' do
      visit @event.url
      expect(page).to have_content("Sign Up or Login to register for this event")
    end

    it 'displays the event title' do
      visit @event.url
      expect(page).to have_content(@event.name)
    end
  end

  context 'registration is not open' do
    before(:each) do
      @opening_tier.date = Time.now  + 1.day
      @opening_tier.save
    end

    it 'displays the event title' do
      visit @event.url
      expect(page).to have_content(@event.name)
    end

    it 'shows the user the countdown' do
      visit @event.url
      expect(page.current_url).to include('countdown')
    end
  end

  context 'registration is closed' do
    it 'displays the event title' do
      visit @event.url
      expect(page).to have_content(@event.name)
    end
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

  context 'shirts' do
    before(:each) do
      @shirt1 = create(:shirt, host: @event)
      @shirt2 = create(:shirt, host: @event)
      @package = create(:package, event: @event)

      visit @event.url
      selects_package
      provides_address
      selects_orientation
    end

    it 'submits with 0 shirts' do
      submit_form
      expect(page).to_not have_content(@shirt1.name)
    end

    it 'submits with multiple shirts of different sizes' do
      fill_in "attendance_metadata_shirts_#{@shirt1.id}_SM_quantity", with: 2
      fill_in "attendance_metadata_shirts_#{@shirt2.id}_M_quantity", with: 1
      fill_in "attendance_metadata_shirts_#{@shirt2.id}_L_quantity", with: 1

      submit_form
      expect(page).to have_content(@shirt1.name)
      expect(page).to have_content(@shirt2.name)
      expect(page).to have_content("2 x SM")
      expect(page).to have_content("1 x M")
      expect(page).to have_content("1 x L")
    end

    it 'edits the shirts' do
      fill_in "attendance_metadata_shirts_#{@shirt1.id}_SM_quantity", with: 2
      fill_in "attendance_metadata_shirts_#{@shirt2.id}_M_quantity", with: 1
      fill_in "attendance_metadata_shirts_#{@shirt2.id}_L_quantity", with: 1

      submit_form
      edit_registration

      fill_in "attendance_metadata_shirts_#{@shirt1.id}_SM_quantity", with: 5
      fill_in "attendance_metadata_shirts_#{@shirt2.id}_L_quantity", with: 0

      submit_form

      expect(page).to have_content(@shirt1.name)
      expect(page).to have_content(@shirt2.name)
      expect(page).to have_content("5 x SM")
      expect(page).to have_content("1 x M")
      expect(page).to_not have_content("x L")
    end
  end

  # have testevent.test.local.vhost
  # in /etc/hosts
  context 'discounts', js: true do
    before(:each) do
      registers_for_event
    end

    it 'discount is allowed to be used 0 times' do
      @discount.allowed_number_of_uses = 0
      @discount.save

      fill_in "discount", with: @discount.name
      click_anchor "#discount_for_#{@discount.id}"
      expect(page).to_not have_content(@discount.name)
    end

    it 'discount is allowed to be used 1 time' do
      @discount.allowed_number_of_uses = 1
      @discount.save

      fill_in "discount", with: @discount.name
      click_anchor "#discount_for_#{@discount.id}"
      expect(page).to have_content(@discount.name)
    end

    it 'applies a discount with a special (URL) characters' do
      @discount.code = "J?J%J"
      @discount.save

      fill_in "discount", with: @discount.name
      click_anchor "#discount_for_#{@discount.id}"
      expect(page).to have_content(@discount.name)

    end

    it 'applies a discount' do
      fill_in "discount", with: @discount.name
      within ".discount-container" do
        click_anchor ".button"
      end
      expect(page).to have_content(@discount.name)
    end

    it 'cannot find the discount code' do
      fill_in "discount", with: "exists?"
      within ".discount-container" do
        click_anchor ".button"
      end
      expect(page).to_not have_content("exists?")
    end
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


  context 'contact information' do
    before(:each) do
      @package = create(:package, event: @event)
    end

    it 'is volunteering' do
      visit @event.url
      is_volunteering
      selects_orientation
      selects_package
      provides_address
      provides_phone_number
      expect{
        submit_form
        expect(page).to_not have_content("error")
      }.to change(@event.attendances, :count).by(1)
    end
  end

  context 'housing' do

  end

end
