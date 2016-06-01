class OrderMailer < ApplicationMailer
  def receipt(for_order: nil)
    @order = for_order
    @host = @order.host
    @buyer_name = @order.buyer_name

    domain = APPLICATION_CONFIG['domain'][Rails.env]
    path = @order.host.subdomain
    @order_url = "//#{domain}/#{path}/#{@order.id}"

    @order_url += "?token=#{@order.payment_token}" if @order.payment_token

    to_email = @order.buyer_email

    options = {
      to: to_email,
      subject: "Payment Received for #{@host.name}"
    }

    if (org_email = @host.try(:notify_email)).present?
      all_purchases_notification = @host.try(:email_all_purchases)
      membership_notification = (
        @order.has_membership? and @host.try(:email_membership_purchases)
      )

      bcc_emails = org_email.split(/[,;]/).map(&:strip)

      options[:bcc] = [org_email] if all_purchases_notification or membership_notification
    end

    if to_email.present?
      mail(options)
    end
  end
end
