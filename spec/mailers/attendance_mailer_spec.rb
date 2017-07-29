require "spec_helper"

describe RegistrationMailer do


  describe '#thankyou_email' do

    it 'contains the disclaimer for an event' do

      @user = create(:user)
      @event = create(:event, user: @user)
      @registration = create(:registration, event: @event, attendee: @user)
      @order = create(:order, event: @event, user: @user, registration: @registration)

      ActionMailer::Base.deliveries.clear
      @event.registration_email_disclaimer = "disclaimer!"
      @event.save
      @order.reload
      RegistrationMailer.thankyou_email(order: @order).deliver_now
      emails = ActionMailer::Base.deliveries

      expect(emails.count).to eq 1
      expect(emails.first.body.parts.first.body.raw_source).to include("disclaimer!")

    end

    it 'does not contain a disclaimer for an organization' do

      @organization = create(:organization)
      @user = create(:user)

      @order = create(:order, host: @organization, user: @user)

      ActionMailer::Base.deliveries.clear
      expect{
        RegistrationMailer.thankyou_email(order: @order).deliver_now
      }.to_not raise_error

      emails = ActionMailer::Base.deliveries

      expect(emails.count).to eq 1

    end
  end

  describe '#payment_received_email' do

  end


end
