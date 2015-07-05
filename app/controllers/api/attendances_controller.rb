class Api::AttendancesController < APIController

  include SetsEvent


  def index
    @attendances = @event.attendances
    render json: @attendances
  end

  def show
    @attendance = @event.attendances.find(params[:id])
    render json: @attendance
  end

end
