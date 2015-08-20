class Api::RegisteredEventsController < APIController

  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  def index
    @attendances = current_user.event_attendances
    if @attendances.present?
      render json: @attendances,
        each_serializer: RegisteredEventSerializer, root: :registered_events
    else
      # the serializer doesn't catch an empty association when the serializer
      # name is different from the class name.
      render json: { attended_events: [] }
    end
  end

  def show
    @attendance = current_user.attendances.find(params[:id])
    render json: @attendance, serializer: RegisteredEventSerializer
  end

end
