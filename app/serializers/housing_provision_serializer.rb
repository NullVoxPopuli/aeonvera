class HousingProvisionSerializer < ActiveModel::Serializer

  attributes :id, :name,
    :housing_capacity,
    :number_of_showers,
    :can_provide_transportation,
    :transportation_capacity,
    :preferred_gender_to_host,
    :has_pets,
    :smokes,
    :notes


  belongs_to :host
  belongs_to :attendance
end
