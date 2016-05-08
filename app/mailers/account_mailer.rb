class AccountMailer < ApplicationMailer
  def account_cancelled(user)
    @user = user

    mail(
      to: user.email,
      subject: 'ÆONVERA Account Cancelled'
    )
  end
end
