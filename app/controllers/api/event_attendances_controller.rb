class Api::EventAttendancesController < APIController
  include SkinnyControllers::Diet
  include EventLoader

  before_action :set_event, only: [:show]

  def index
    if params[:cancelled]
      @attendances = @event.cancelled_attendances
    else
      @attendances = model
      @attendances = @attendances.unpaid if params[:unpaid]
    end

    render json: @attendances
  end

  def show
    @attendance = @event.attendances.find(params[:id])
    render json: @attendance
  end

end
