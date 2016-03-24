class OrderMailer < ApplicationMailer
  default from: APPLICATION_CONFIG['support_email']
  # add_template_helper RegisterHelper
  layout "email"

  def receipt(for_order: nil)
    @order = for_order
    @host = @order.host
    @buyer_name = @order.buyer_name

    to_email = @order.buyer_email

    if to_email.present?
      mail(to: to_email, subject: "Payment Received for #{@host.name}")
    end
  end
end
