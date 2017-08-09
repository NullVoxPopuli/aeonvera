# frozen_string_literal: true

require 'rails_helper'

describe MembershipMailer, type: :mailer do
  let(:owner) { create_confirmed_user }
  let(:org) { create(:organization, owner: owner) }
  let(:user) { create_confirmed_user }
  let(:membership_option) { create(:membership_option, organization: org) }

  describe :one_week_expiration do
    it 'renders the header with the org name' do
      renewal = create(:membership_renewal, membership_option: membership_option, user: user)
      ActionMailer::Base.deliveries.clear
      MembershipMailer.one_week_expiration(user, renewal, org).deliver_now
      email = ActionMailer::Base.deliveries.first
      body = email.body.raw_source

      expect(body).to include("<h1>#{org.name}")
    end
  end
end
