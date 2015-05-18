class API::AttendedEventsController < APIController

  def index
    @attendances = current_user.event_attendances
    render json: @attendances
  end

  def show
    @attendance = current_user.attendances.find(params[:id])
    render json: @attendance
  end

end
