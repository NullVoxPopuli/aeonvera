class Api::HousingRequestsController < APIController
  include SetsEvent
  include LazyCrud


  set_resource HousingRequest
  set_resource_parent Event
  set_param_whitelist(
    :need_transportation, :can_provide_transportation,
    :transportation_capacity,
    :allergic_to_pets, :allergic_to_smoke, :other_allergies,
    :requested_roommates, :unwanted_roommates,
    :preferred_gender_to_house_with,
    :notes,
    :attendance_id, :attendance_type,
    :housing_provision_id
  )

  def index
    @housing_requests = @event.housing_requests
    # render json: @housing_requests
    respond_with @housing_requests
  end
end
