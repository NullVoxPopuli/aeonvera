class HostedEvents::CheckinController < ApplicationController
  include SetsEvent


  before_action :load_attendance, only: [:update]

  def index
    # list of everyone
    @checked_in = @event.attendances.where("checked_in_at IS NOT NULL").count
    @not_checked_in = @event.attendances.where("checked_in_at IS NULL").count
    if (attending_count = @event.attendances.count.to_f) > 0
      @checked_in_percent = ((@checked_in / attending_count) * 100).round
    else
      @checked_in_percent = 0
    end
  end

  def update
    # update checkin, update payment, etc
    if params[:competition]
      checkin_and_crossover
    elsif params[:checkin] == "true"
      checkin
    elsif params[:checkin] == "false"
      uncheckin
    elsif params[:payment_method]
      mark_paid
    end
  end


  private


  def mark_paid
    payment_method = params[:payment_method]
    if Payable::Methods::ALL.include?(payment_method)

      @attendance.mark_orders_as_paid!(check_number: params[:check_number])

      if @attendance.owes_nothing?
        return render file: '/hosted_events/checkin/mark_paid'
      else
        return render file: '/hosted_events/checkin/error.js.erb'
      end
    end

    # if something didn't flow correctly, just don't do anything
    render nothing: true
  end

  def checkin_and_crossover
    @attendance.crossover_orientation = params[:competition][:orientation]
    checkin
  end

  def checkin
    @attendance.checkin!
    if @attendance.save
      flash.now[:notice] = "Attendee has been checked in."
    else
      flash.now[:error] = "Something went wrong. The Attendee has not been checked in."
    end

    render file: '/hosted_events/checkin/checkin'
  end

  def uncheckin
    @attendance.uncheckin!
    if @attendance.save
      flash.now[:notice] = "Attendee has been un-checked in."
    else
      flash.now[:error] = "Something went wrong. The Attendee has not been un checked in."
    end

    render file: '/hosted_events/checkin/uncheckin'
  end


  def load_attendance
    @attendance = @event.attendances.find(params[:id])
  end
end
