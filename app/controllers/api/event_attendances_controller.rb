class Api::EventAttendancesController < APIController
  # TODO: should the parent object be set by lazy_crud?
  include LazyCrud
  include EventLoader

  before_action :set_event, only: [:index, :show]

  set_param_whitelist(
    :dance_orientation,
    :checked_in_at)

  def index
    @attendances = @event.attendances
    render json: @attendances
  end

  def show
    @attendance = @event.attendances.find(params[:id])
    render json: @attendance
  end

end
