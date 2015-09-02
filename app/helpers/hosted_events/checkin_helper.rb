module HostedEvents::CheckinHelper

  def checkin_pay_link(attendance: nil, amount: attendance.amount_owed, payment_method: Payable::Method::PAYPAL, path: '')
    link_to(
      send("#{path}_path",
        hosted_event_id: @event.id,
        id: attendance.id,
        payment_method: payment_method
      ),
      remote: true,
      method: :put,
      data: {
        confirm: "Confirm that #{number_to_currency(amount)} has been collected via #{payment_method} for #{attendance.attendee_name}"
      }
    ) do
      payment_method
    end
  end

end
