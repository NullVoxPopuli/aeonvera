class AttendanceMailer < ActionMailer::Base
  add_template_helper(RegisterHelper)

  default from: APPLICATION_CONFIG["support_email"]

  layout "email"

  def thankyou_email(order: nil)
    build_email(order: order, subject: Proc.new{
      "Thank you for registering #{@preposition} #{@event.name}"
    })
  end

  def payment_received_email(order: nil)
    build_email(order: order, subject: Proc.new{
      "Payment Received #{@preposition} #{@event.name}"
    })
  end

  private

  def build_email(order: nil, subject: nil)
    @order = order
    @event = order.host
    @attendance = Attendance.with_deleted.find(order.attendance_id)
    @preposition = @event.is_a?(Event) ? "for" : "with"

    attendee = @attendance.attendee

    email = attendee.present? ? attendee.email : @attendance.metadata["email"]

    if email.present?
      mail(
        to: email,
        subject: subject.call
        )
      end
  end
end
