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

  context 'user has not yet paid, and wants to edit' do
    before(:each) do
      @package = create(:package, event: @event)
      @package2 = create(:package, event: @event)

      visit @event.url
      selects_orientation
      selects_package
      provides_address
      submit_form
      # revisit the URL to get redirected to the path with the id
      visit @event.url

      @p2 = create(:pricing_tier,
        event: @event,
        date: 1.day.from_now,
        increase_by_dollars: 3)
      @c1 = create(:competition,
        event: @event,
        kind: Competition::SOLO_JAZZ,
        name: 'solo')

      @id = current_url.split('/').last
    end

    it 'is assigned the opening tier id' do
      attendance = @event.attendances.find(@id)
      actual = attendance.pricing_tier.id
      expect(actual).to eq @event.opening_tier.id
    end

    context 'a new tier is active' do
      before(:each) do
        Delorean.jump 4.days
        # sanity
        @event.reload
        expect(@event.current_tier).to_not eq @event.opening_tier
        expect(@event.current_tier).to eq @p2
      end

      after(:each) do
        Delorean.back_to_the_present
      end

      it 'keeps the originating tier after editing' do
        edit_registration
        selects_package(@package2)
        submit_form
        actual = @event.attendances.find(@id).pricing_tier.id
        expect(actual).to eq @event.opening_tier.id
      end

      it 'does not change the price' do
        old_total = @event.attendances.find(@id).amount_owed
        edit_registration
        check_box_with_id("#attendance_competition_responses_attributes_0__destroy")
        selects_package(@package2)
        submit_form

        attendance = @event.attendances.find(@id)
        new_total = attendance.amount_owed
        actual = attendance.pricing_tier.id

        expect(actual).to eq @event.opening_tier.id
        expect(new_total).to eq old_total + @c1.current_price
      end
    end
  end

end
