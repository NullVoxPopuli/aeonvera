class HousingRequestSerializer < ActiveModel::Serializer

  attributes :id,
    :needs_transportation, :can_provide_transportation, :transportation_capacity,
    :allergic_to_pets, :allergic_to_smoke, :other_allergies,
    :requested_roommates, :unwanted_roommates,
    :preferred_gender_to_house_with,
    :notes,
    :attendance_id, :attendance_type,
    :host_id, :host_type,
    :housing_provision_id

end
