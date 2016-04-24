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

  def deserialized_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(
      params,
      embedded: [
        :housing_request,
        :housing_provision
      ],
      polymorphic: [:host])
  end

  def create_event_attendance_params
    whitelister = ActionController::Parameters.new(deserialized_params)
    whitelister.permit(
      # Attendance Attributes
      :phone_number, :interested_in_volunteering,
      :city, :state, :zip,
      :dance_orientation,

      # Relationships
      :package_id, :level_id, :attendee_id, :pricing_tier_id,
      :host_id, :host_type,

      housing_request_attributes: [
        :need_transportation, :can_provide_transportation,
        :transportation_capacity,
        :allergic_to_pets, :allergic_to_smoke, :other_allergies,
        :preferred_gender_to_house_with, :notes,
        :requested_roommates => [], :unwanted_roommates => [],
      ],
      housing_provision_attributes: [
        :housing_capacity, :number_of_showers, :can_provide_transportation,
        :transportation_capacity, :preferred_gender_to_host,
        :has_pets, :smokes, :notes
      ]
    )
  end

  def update_event_attendance_params
    blacklisted = [:host_id, :host_type]
    create_event_attendance_params.reject{ |k, v| blacklisted.include?(k) }
  end

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
