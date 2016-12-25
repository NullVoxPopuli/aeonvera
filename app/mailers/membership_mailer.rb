class MembershipMailer < ApplicationMailer

  # only called from the membership_reminder_job,
  # so this should not be called with deliver later.
  def one_week_expiration(member, renewal, org)
    template = slim(%Q{
      Hello, #{member.name},
      br
      Your membership for #{org.name} is set to expire at
      #{renewal.expires_at.to_s(:short)}.
      br
      Please visit <a href=#{org.url}>#{org.url}</a> to purchase
      a membership renewal.
      br
      br
    })

    mail(
      to: member.email,
      subject: "Your membership for #{org.name} is going to expire soon",
      body: template
    )
  end
end
