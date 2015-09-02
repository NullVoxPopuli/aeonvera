module MarkPaid
  extend ActiveSupport::Concern


  def mark_paid(skip: false)
    payment_method = params[:payment_method]
    if Payable::Methods::ALL.include?(payment_method)

      unless skip
        @attendance.mark_orders_as_paid!(check_number: params[:check_number], payment_method: payment_method)
      end

      if @attendance.owes_nothing?
        return render file: '/hosted_events/checkin/mark_paid'
      else
        return render file: '/hosted_events/checkin/error.js.erb'
      end
    end

    # if something didn't flow correctly, just don't do anything
    render nothing: true
  end

end
