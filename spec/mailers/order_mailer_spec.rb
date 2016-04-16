require "spec_helper"

RSpec.describe OrderMailer, type: :mailer do
  before(:each) do
    @user = create_confirmed_user
  end

  it 'sends a receipt' do
    o = create(:order, user: @user, attendance: create(:attendance))
    ActionMailer::Base.deliveries.clear

    expect{
      OrderMailer.receipt(for_order: o).deliver_now
    }.to change(ActionMailer::Base.deliveries, :count).by 1
  end

  it 'does not include the processing fee' do
    e = create(:event, make_attendees_pay_fees: false)
    o = create(:order, host: e, user: @user, attendance: create(:attendance))
    allow(o).to receive(:total_fee_amount){ 5 }

    ActionMailer::Base.deliveries.clear
    OrderMailer.receipt(for_order: o).deliver_now
    email = ActionMailer::Base.deliveries.first
    body = email.body.raw_source

    expect(body).to_not include("Processing Fee")
  end

  it 'does include the processing fee' do
    e = create(:event, make_attendees_pay_fees: true)
    o = create(:order, host: e, user: @user, attendance: create(:attendance))
    allow(o).to receive(:total_fee_amount){ 5 }

    ActionMailer::Base.deliveries.clear
    OrderMailer.receipt(for_order: o).deliver_now
    email = ActionMailer::Base.deliveries.first
    body = email.body.raw_source

    expect(body).to include("Processing Fee")
  end

  it 'shows the payment token when present' do
    token = 'abctoken'
    o = create(:order, user: @user, payment_token: token, attendance: create(:attendance))
    ActionMailer::Base.deliveries.clear
    OrderMailer.receipt(for_order: o).deliver_now
    email = ActionMailer::Base.deliveries.first
    body = email.body.raw_source

    expect(body).to include(token)
  end

end
