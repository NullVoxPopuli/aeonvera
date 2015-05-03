require 'spec_helper'

describe HostedEvents::PaymentsController do


  before(:each) do
    login
    @event = create(:event, hosted_by: @user)
    @package = create(:package, event: @event)
    @attendance = create(:attendance, event: @event, attendee: @user, package: @package)
    @attendance.create_order
    @order = @attendance.orders.last

    expect(@attendance.orders).to_not be_empty

    allow(controller).to receive(:load_integration){ true }
    allow(controller).to receive(:charge_card!){ true }
  end

  describe '#create' do
    it 'posts the payment information' do
      post :create, hosted_event_id: @event.id, order_id: @order.id
      expect(response).to be_redirect
    end

    it 'posts from a subdomain' do
      post :create, hosted_event_id: @event.id, order_id: @order.id
      expect(response).to be_redirect
    end

    it 'sends an email' do
      ActionMailer::Base.deliveries.clear

      post :create, hosted_event_id: @event.id, order_id: @order.id

      emails = ActionMailer::Base.deliveries
      expect(emails.length).to eq 1
      expect(emails.first.subject).to include(@event.name)
      expect(emails.first.subject).to include("Payment")
    end
  end


end
