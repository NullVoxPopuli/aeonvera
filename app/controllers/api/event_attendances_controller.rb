class Api::EventAttendancesController < APIController
  # TODO: should the parent object be set by lazy_crud?
  include LazyCrud
  include EventLoader

  before_action :set_event, only: [:index, :show]

  set_param_whitelist(
    :dance_orientation,
    :checked_in_at)

  def index
    if params[:cancelled]
      @attendances = @event.cancelled_attendances
    else
      @attendances = @event.attendances
      @attendances = @attendances.unpaid if params[:unpaid]
    end
    
    render json: @attendances
  end

  def show
    @attendance = @event.attendances.find(params[:id])
    render json: @attendance
  end

end
