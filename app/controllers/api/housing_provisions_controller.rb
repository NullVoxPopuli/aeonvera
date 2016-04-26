class Api::HousingProvisionsController < Api::EventResourceController
  private

  def deserialized_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(
      params, polymorphic: [:attendance])
  end

  def update_housing_request_params
    whitelister = ActionController::Parameters.new(deserialized_params)
    whitelister.permit(
      :housing_capacity, :number_of_showers, :can_provide_transportation,
      :transportation_capacity, :preferred_gender_to_host,
      :has_pets, :smokes, :notes
    )
  end

  def create_housing_request_params
    whitelister = ActionController::Parameters.new(deserialized_params)
    whitelister.permit(
      :housing_capacity, :number_of_showers, :can_provide_transportation,
      :transportation_capacity, :preferred_gender_to_host,
      :has_pets, :smokes, :notes,
      :attendance_id, :attendance_type,
      :host_id, :host_type
    )
  end
end
