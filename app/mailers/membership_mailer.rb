# frozen_string_literal: true
class MembershipMailer < ApplicationMailer
  # only called from the membership_reminder_job,
  # so this should not be called with deliver later.
  def one_week_expiration(member, renewal, org)
    template = slim(%(
      = content_for :header
        = org.name
      Hello, #{member.name},
      br
      Your membership for #{org.name} is set to expire at
      #{renewal.expires_at.to_s(:short)}.
      br
      Please visit <a href=#{org.url}>#{org.url}</a> to purchase
      a membership renewal.
      br
      br
    ))

    subject = "Your membership for #{org.name} is going to expire soon"
    mail(to: member.email, subject: subject) do |format|
      format.html { render text: template }
    end
  end
end
