# frozen_string_literal: true
module Api
  class HousingRequestsController < Api::EventResourceController
    private

    def update_housing_request_params
      whitelistable_params(polymorphic: [:host]) do |whitelister|
        whitelister.permit(
          :need_transportation, :can_provide_transportation,
          :transportation_capacity, :name,
          :allergic_to_pets, :allergic_to_smoke, :other_allergies,
          :preferred_gender_to_house_with, :notes,
          :housing_provision_id,
          requested_roommates: [], unwanted_roommates: []
        )
      end
    end

    def create_housing_request_params
      whitelistable_params(polymorphic: [:host]) do |whitelister|
        whitelister.permit(
          :need_transportation, :can_provide_transportation,
          :transportation_capacity, :name,
          :allergic_to_pets, :allergic_to_smoke, :other_allergies,
          :preferred_gender_to_house_with, :notes,
          :registration_id, :registration_type, :host_id, :host_type,
          :housing_provision_id,
          requested_roommates: [], unwanted_roommates: []
        )
      end
    end
  end
end
