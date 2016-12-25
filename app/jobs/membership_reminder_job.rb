# frozen_string_literal: true
#
# run through all memberships, and see if they
# have a week before their membership ends.
# This should run nightly.
class MembershipReminderJob < ApplicationJob
  ONE_WEEK = 1.week.freeze

  def perform
    now = Time.now

    Organization.all.each do |org|
      org.members.each do |member|
        renewal = member.latest_active_renewal(org)

        next unless renewal
        next unless should_send_email(renewal, now)

        MembershipMailer.one_week_expiration(member, renewal, org).deliver_now
      end
    end
  end

  def should_send_email(renewal, now)
    expires_at = renewal.expires_at
    when_to_remind = expires_at - ONE_WEEK

    when_to_remind < now
  end
end
