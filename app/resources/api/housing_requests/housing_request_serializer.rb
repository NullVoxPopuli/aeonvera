module Api
  class HousingRequestSerializer < ActiveModel::Serializer
    attributes :id, :notes, :name,
               :need_transportation, :can_provide_transportation,
               :transportation_capacity,
               :allergic_to_pets, :allergic_to_smoke, :other_allergies,
               :requested_roommates, :unwanted_roommates,
               :preferred_gender_to_house_with,
               :housing_provision_id

    belongs_to :host
    belongs_to :attendance
    belongs_to :housing_provision
  end
end
