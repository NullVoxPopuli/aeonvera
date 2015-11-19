module OrderOperations
    class SendReceipt < Base
    def run
      if allowed?
        AttendanceMailer.payment_received_email(order: model).deliver_now
      else
        # TODO: how to sent error to ember?
        raise 'not authorized'
      end
    end
  end
end
