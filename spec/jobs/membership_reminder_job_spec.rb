# frozen_string_literal: true

require 'rails_helper'

describe MembershipReminderJob do
  let(:owner) { create_confirmed_user }
  let(:org) { create(:organization, owner: owner) }
  let(:user) { create_confirmed_user }
  let(:membership_option) {
    create(:membership_option,
           organization: org, duration_unit: 3, duration_amount: 1)
  }

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it 'does not send before a week' do
    create(:membership_renewal,
           membership_option: membership_option,
           user: user,
           start_date: 1.year.ago + 9.days)

    ActionMailer::Base.deliveries.clear
    MembershipReminderJob.perform_now
    expect(ActionMailer::Base.deliveries.first).to be_nil
  end

  it 'sends when there is one week before expiration' do
    create(:membership_renewal,
           membership_option: membership_option,
           user: user,
           start_date: 1.year.ago + 6.days)

    ActionMailer::Base.deliveries.clear
    MembershipReminderJob.perform_now
    expect(ActionMailer::Base.deliveries.first).to_not be_nil
  end

  it 'does not spend if the expiration has hit' do
    create(:membership_renewal,
           membership_option: membership_option,
           user: user,
           start_date: 1.year.ago - 1.day)

    ActionMailer::Base.deliveries.clear
    MembershipReminderJob.perform_now
    expect(ActionMailer::Base.deliveries.first).to be_nil
  end
end
