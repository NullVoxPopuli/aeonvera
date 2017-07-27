require "spec_helper"

RSpec.describe OrderMailer, type: :mailer do
  before(:each) do
    @user = create_confirmed_user
  end

  it 'sends a receipt' do
    o = create(:order, user: @user, attendance: create(:registration))
    ActionMailer::Base.deliveries.clear

    expect{
      OrderMailer.receipt(for_order: o).deliver_now
    }.to change(ActionMailer::Base.deliveries, :count).by 1
  end

  it 'does not include the processing fee' do
    e = create(:event, make_attendees_pay_fees: false)
    o = create(:order, host: e, user: @user, attendance: create(:registration))
    allow(o).to receive(:total_fee_amount){ 5 }

    ActionMailer::Base.deliveries.clear
    OrderMailer.receipt(for_order: o).deliver_now
    email = ActionMailer::Base.deliveries.first
    body = email.body.raw_source

    expect(body).to_not include("Processing Fee")
  end

  it 'does include the processing fee' do
    e = create(:event, make_attendees_pay_fees: true)
    o = create(:order, host: e, user: @user, attendance: create(:registration))
    allow(o).to receive(:total_fee_amount){ 5 }

    ActionMailer::Base.deliveries.clear
    OrderMailer.receipt(for_order: o).deliver_now
    email = ActionMailer::Base.deliveries.first
    body = email.body.raw_source

    expect(body).to include("Processing Fee")
  end

  it 'shows the payment token when present' do
    token = 'abctoken'
    o = create(:order, user: @user, payment_token: token, attendance: create(:registration))
    ActionMailer::Base.deliveries.clear
    OrderMailer.receipt(for_order: o).deliver_now
    email = ActionMailer::Base.deliveries.first
    body = email.body.raw_source

    expect(body).to include(token)
  end

  it 'shows the contact email when present' do
    host = create(:event, contact_email: 'test@test.abc')
    o = create(:order, user: @user, attendance: create(:registration), host: host)
    ActionMailer::Base.deliveries.clear

    OrderMailer.receipt(for_order: o).deliver_now
    email = ActionMailer::Base.deliveries.first
    body = email.body.raw_source
    expect(body).to include('organizers.</a>')
    expect(body).to include('test@test.abc')
  end

  it 'does not show a contact email when there is not one present' do
    host = create(:event)
    o = create(:order, user: @user, attendance: create(:registration), host: host)
    ActionMailer::Base.deliveries.clear

    OrderMailer.receipt(for_order: o).deliver_now
    email = ActionMailer::Base.deliveries.first
    body = email.body.raw_source
    expect(body.gsub("\n", '')).to include('email  the organizers.')
  end

  describe 'organization email notifications' do
    before(:each) do
      @org = create(:organization)
      @member_option = create(:membership_option, host: @org)
      @lesson = create(:line_item, host: @org)
    end

    it 'does not bcc without an email' do
      @org.notify_email = ''
      @org.save
      o = create(:order, user: @user, host: @org)
      add_to_order(o, @member_option)
      o.save

      ActionMailer::Base.deliveries.clear

      OrderMailer.receipt(for_order: o).deliver_now
      email = ActionMailer::Base.deliveries.first
      expect(email.bcc).to be_nil
    end

    it 'bccs on a purchase' do
      @org.notify_email = 'test@testorg.test'
      @org.email_all_purchases = true
      @org.save
      o = create(:order, user: @user, host: @org)
      add_to_order(o, @lesson, price: 1)
      o.save

      ActionMailer::Base.deliveries.clear

      OrderMailer.receipt(for_order: o).deliver_now
      email = ActionMailer::Base.deliveries.first
      expect(email.bcc).to eq [@org.notify_email]
    end

    it 'bccs with multiple emails' do
      @org.notify_email = 'test@testorg.test, test1@testorg.test; test2@testorg.test'
      @org.email_all_purchases = true
      @org.save
      o = create(:order, user: @user, host: @org, buyer_email: 'buyer@gmail.com')
      add_to_order(o, @lesson, price: 1)
      o.save

      ActionMailer::Base.deliveries.clear

      OrderMailer.receipt(for_order: o).deliver_now
      email = ActionMailer::Base.deliveries.first

      expect(email.to).to include('buyer@gmail.com')
      expect(email.bcc).to include('test@testorg.test')
      expect(email.bcc).to include('test1@testorg.test')
      expect(email.bcc).to include('test2@testorg.test')
    end

    it 'bccs on a membership' do
      @org.notify_email = 'test@testorg.test'
      @org.email_membership_purchases = true
      @org.save
      o = create(:order, user: @user, host: @org)
      oli = add_to_order(o, @member_option)
      oli.save
      o.save

      ActionMailer::Base.deliveries.clear

      OrderMailer.receipt(for_order: o).deliver_now
      email = ActionMailer::Base.deliveries.first
      expect(email.bcc).to eq [@org.notify_email]
    end

    it 'does not bcc if only configured for a membership notification and the order has no membership' do
      @org.notify_email = 'test@testorg.test'
      @org.email_membership_purchases = true
      @org.save
      o = create(:order, user: @user, host: @org)
      add_to_order(o, @lesson, price: 1)
      o.save

      ActionMailer::Base.deliveries.clear

      OrderMailer.receipt(for_order: o).deliver_now
      email = ActionMailer::Base.deliveries.first
      expect(email.bcc).to be_nil
    end
  end

end
