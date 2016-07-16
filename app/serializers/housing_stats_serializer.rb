class HousingStatsSerializer < ActiveModel::Serializer
  type 'housing_stats'

  attributes :id,
    :requests, :provisions

  has_many :housing_requests
  has_many :housing_provisions

  def requests
    object.housing_requests.count
  end

  def provisions
    object.housing_provisions.map(&:housing_capacity).map(&:to_i).inject(:+) || 0
  end

end
