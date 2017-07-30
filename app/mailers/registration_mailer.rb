# frozen_string_literal: true

class RegistrationMailer < ActionMailer::Base
  default from: APPLICATION_CONFIG['support_email']

  layout 'email'

  def thankyou_email(order: nil)
    build_email(order: order, subject: proc do
      "Thank you for registering #{@preposition} #{@event.name}"
    end)
  end

  def payment_received_email(order: nil)
    build_email(order: order, subject: proc do
      "Payment Received #{@preposition} #{@event.name}"
    end)
  end

  private

  def build_email(order: nil, subject: nil)
    @order = order
    @event = order.host
    @registration = Registration.with_deleted.find(order.registration_id)
    @preposition = @event.is_a?(Event) ? 'for' : 'with'

    attendee = @registration.attendee

    email = attendee.present? ? attendee.email : @registration.metadata['email']

    return unless email.present?

    mail(
      to: email,
      subject: subject.call
    )
  end
end
