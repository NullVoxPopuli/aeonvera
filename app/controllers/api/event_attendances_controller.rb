class Api::EventAttendancesController < APIController
  include SkinnyControllers::Diet
  include EventLoader
  self.model_class = Attendance

  def index
    if params[:cancelled]
      set_event
      @attendances = @event.cancelled_attendances
    else
      @attendances = model
      @attendances = @attendances.unpaid if params[:unpaid]
    end

    render json: @attendances
  end

  def show
    render json: model
  end

end
