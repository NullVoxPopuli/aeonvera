class HostedEvents::CancelledAttendancesController < ApplicationController

  include SetsEvent
  before_action :set_attendance, only: [:edit, :update, :destroy]


  layout "hosted_events"

  def index
    @attendances = @event.cancelled_attendances

    respond_to do |format|
      format.html{}
      format.csv{
        send_data @attendances.to_csv
      }
    end
  end

  def destroy
    unless @attendance
      flash[:alert] = "Attendance not found"
      redirect_to action: :index
      return
    end

    @attendance.attending = true
    @attendance.save
    respond_to do |format|
      format.html {
        flash[:notice] = "#{@attendance.attendee_name} is marked as now attending."
        redirect_to hosted_event_attendances_path(@event)
      }
      format.json { head :no_content }
    end
  end
  def set_attendance
    @attendance = @event.cancelled_attendances.find_by_id(params[:id])
  end
end
