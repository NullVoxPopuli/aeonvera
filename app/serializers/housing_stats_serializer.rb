class HousingStatsSerializer < ActiveModel::Serializer
  type 'housing_stats'

  attributes :id,
    :requests, :provisions

  def requests
    object.housing_requests.count
  end

  def provisions
    object.housing_provisions.map(&:housing_capacity).inject(:+)
  end

end
