class Api::HousingProvisionsController < Api::EventResourceController
  private

  def update_housing_provision_params
    whitelistable_params(polymorphic: [:attendance, :host]) do |whitelister|
      whitelister.permit(
        :housing_capacity, :number_of_showers, :can_provide_transportation,
        :transportation_capacity, :preferred_gender_to_host,
        :has_pets, :smokes, :notes
      )
    end
  end

  def create_housing_provision_params
    whitelistable_params(polymorphic: [:attendance, :host]) do |whitelister|
      whitelister.permit(
        :housing_capacity, :number_of_showers, :can_provide_transportation,
        :transportation_capacity, :preferred_gender_to_host,
        :has_pets, :smokes, :notes,
        :attendance_id, :attendance_type,
        :host_id, :host_type
      )
    end
  end
end
