# frozen_string_literal: true
require 'spec_helper'

describe RegistrationMailer do
  describe '#thankyou_email' do
    it 'contains the disclaimer for an event' do
      @user = create(:user)
      @event = create(:event, user: @user)
      @registration = create(:registration, event: @event, attendee: @user)
      @order = create(:order, event: @event, user: @user, registration: @registration)

      ActionMailer::Base.deliveries.clear
      @event.registration_email_disclaimer = 'disclaimer!'
      @event.save
      @order.reload
      RegistrationMailer.thankyou_email(order: @order).deliver_now
      emails = ActionMailer::Base.deliveries

      expect(emails.count).to eq 1
      expect(emails.first.body.parts.first.body.raw_source).to include('disclaimer!')
    end
  end

  describe '#payment_received_email' do
  end
end
