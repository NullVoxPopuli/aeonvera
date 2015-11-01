class HousingProvisionSerializer < ActiveModel::Serializer

  attributes :id,
    :housing_capacity,
    :number_of_showers,
    :can_provide_transportation,
    :transportation_capacity,
    :preferred_gender_to_host,
    :has_pets,
    :smokes,
    :notes,
    :attendance_id, :attendance_type,
    :host_id, :host_type

end
