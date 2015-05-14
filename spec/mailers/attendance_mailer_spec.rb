require "spec_helper"

describe AttendanceMailer do
  before(:each) do
    @user = create(:user)
    @event = create(:event, user: @user)
    @attendance = create(:attendance, event: @event, attendee: @user)
    @order = create(:order, event: @event, user: @user, attendance: @attendance)

    ActionMailer::Base.deliveries.clear
  end

  describe '#thankyou_email' do

    it 'contains the disclaimer' do
      @event.registration_email_disclaimer = "disclaimer!"
      @event.save
      @order.reload
      AttendanceMailer.thankyou_email(order: @order).deliver
      emails = ActionMailer::Base.deliveries

      expect(emails.count).to eq 1
      expect(emails.first.body.raw_source).to include("disclaimer!")

    end
  end

  describe '#payment_received_email' do

  end


end
