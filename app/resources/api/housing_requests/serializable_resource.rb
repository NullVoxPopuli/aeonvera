# frozen_string_literal: true

module Api
  class HousingRequestSerializableResource < ApplicationResource
    type 'housing-requests'

    attributes :notes, :name,
               :need_transportation, :can_provide_transportation,
               :transportation_capacity,
               :allergic_to_pets, :allergic_to_smoke, :other_allergies,
               :requested_roommates, :unwanted_roommates,
               :preferred_gender_to_house_with,
               :housing_provision_id

    belongs_to :host,
               class: { Event: '::Api::EventSerializableResource',
                        Organization: '::Api::OrganizationSerializableResource' } do
      linkage always: true
    end

    belongs_to :registration, class: '::Api::Users::RegistrationSerializableResource' do
      linkage always: true
    end

    belongs_to :housing_provision, class: '::Api::HousingProvisionSerializableResource' do
      linkage always: true
    end
  end
end
