class AttendanceMailer < ActionMailer::Base
  add_template_helper(RegisterHelper)

  default from: APPLICATION_CONFIG["support_email"]

  layout "email"

  def thankyou_email(order: nil)
    @order = order
  	@event = order.host
  	@attendance = Attendance.with_deleted.find(order.attendance_id)
    @preposition = @event.is_a?(Event) ? "for" : "with"
  	mail(
      to: @attendance.attendee.email,
      subject: "Thank you for registering #{@preposition} #{@event.name}"
      )
  end

  def payment_received_email(order: nil)
    @order = order
    @event = order.host
    @attendance = Attendance.with_deleted.find(order.attendance_id)
    @preposition = @event.is_a?(Event) ? "for" : "with"

    mail(
      to: @attendance.attendee.email,
      subject: "Payment Received #{@preposition} #{@event.name}"
      )
  end
end
