class Api::AttendedEventsController < APIController

  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  def index
    @attendances = current_user.event_attendances
    render json: @attendances,
      each_serializer: AttendedEventSerializer
  end

  def show
    @attendance = current_user.attendances.find(params[:id])
    render json: @attendance, serializer: AttendedEventSerializer
  end

end
