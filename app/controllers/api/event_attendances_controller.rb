class Api::EventAttendancesController < APIController
  include SkinnyControllers::Diet
  include EventLoader
  self.model_class = EventAttendance

  def index
    return render_attendance_for_event if requesting_attendance_for_event?

    # TODO: do I still need this param?
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
    return render_attendance_for_event if requesting_attendance_for_event?

    render json: model, include: params[:include]
  end

  def create
    render_model
  end

  def update
    render_model
  end

  private

  def requesting_attendance_for_event?
    params[:current_user] && params[:event_id]
  end

  def render_attendance_for_event
    e = Event.find(params[:event_id])
    attendance = current_user.attendance_for_event(e)

    if attendance
      include_paths = 'package,level,pricing_tier,attendee,unpaid_order.order_line_items.line_item'
      render json: attendance, include: include_paths, serializer: EventAttendanceSerializer
    else
      render json: {}, status: 404
    end
  end

end
