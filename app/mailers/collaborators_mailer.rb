class CollaboratorsMailer < ActionMailer::Base
  default from: APPLICATION_CONFIG["support_email"]

  layout "email"

  def invitation(from: nil, email_to: nil, host: nil, link: nil)
    @user = from
    @link = link
    @host = host

    mail(
      to: email_to,
      subject: "You've been invited to work on #{host.name}"
    )
  end
end
