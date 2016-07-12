class Api::EventAttendancesController < APIController
  include SkinnyControllers::Diet
  include EventLoader
  self.model_class = EventAttendance

  before_filter :must_be_logged_in

  def index
    if params[:q]
      set_event
      search = @event.attendances.includes(:attendee).ransack(search_params)
      return render json: search.result, fields: { 'event-attendance' => ['attendee_name'] }
    end

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

  def search_params
    params.require(:event_id)
    params[:q].merge({
      host_id: params[:event_id],
      host_type: Event.name,
    })
  end

  def show
    return render_attendance_for_event if requesting_attendance_for_event?

    render json: model, include: params[:include]
  end

  def create
    render_model('housing_request,housing_provision,custom_field_responses')
  end

  def update
    render_model('housing_request,housing_provision,custom_field_responses')
  end

  private

  def deserialized_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(
      params,
      embedded: [
        :housing_request,
        :housing_provision,
        :custom_field_responses
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
      ],
      custom_field_responses_attributes: [:value, :custom_field_id]
    )
  end

  def update_event_attendance_params
    whitelister = ActionController::Parameters.new(deserialized_params)
    whitelister.permit(
      # Attendance Attributes
      :phone_number, :interested_in_volunteering,
      :city, :state, :zip,
      :dance_orientation,

      # Relationships
      :package_id, :level_id
    )
  end

  def requesting_attendance_for_event?
    params[:current_user] && params[:event_id]
  end

  def render_attendance_for_event
    e = Event.find(params[:event_id])
    attendance = current_user.attendance_for_event(e)

    if attendance
      include_paths = 'housing_request,housing_provision,package,level,pricing_tier,custom_field_responses,attendee,unpaid_order.order_line_items.line_item'
      render json: attendance, include: include_paths, serializer: EventAttendanceSerializer
    else
      render json: {}, status: 404
    end
  end

end
