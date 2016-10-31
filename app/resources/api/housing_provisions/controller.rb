module Api
  class HousingProvisionsController < Api::EventResourceController
    private

    def update_housing_provision_params
      whitelistable_params(polymorphic: [:attendance, :host]) do |whitelister|
        whitelister.permit(
          :housing_capacity, :number_of_showers, :can_provide_transportation,
          :transportation_capacity, :preferred_gender_to_host,
          :has_pets, :smokes, :notes, :name
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
          :host_id, :host_type, :name
        )
      end
    end
  end
end
