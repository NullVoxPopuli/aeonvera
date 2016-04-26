class Api::HousingRequestsController < Api::EventResourceController
  private

  def deserialized_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(
      params, polymorphic: [:attendance])
  end

  def update_housing_request_params
    whitelister = ActionController::Parameters.new(deserialized_params)
    whitelister.permit(
      :need_transportation, :can_provide_transportation,
      :transportation_capacity,
      :allergic_to_pets, :allergic_to_smoke, :other_allergies,
      :preferred_gender_to_house_with, :notes,
      :housing_provision_id,
      requested_roommates: [], unwanted_roommates: []
    )
  end

  def create_housing_request_params
    whitelister = ActionController::Parameters.new(deserialized_params)
    whitelister.permit(
      :need_transportation, :can_provide_transportation,
      :transportation_capacity,
      :allergic_to_pets, :allergic_to_smoke, :other_allergies,
      :preferred_gender_to_house_with, :notes,
      :attendance_id, :attendance_type, :host_id, :host_type,
      :housing_provision_id,
      requested_roommates: [], unwanted_roommates: []
    )
  end
end
