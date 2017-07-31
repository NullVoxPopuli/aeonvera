# frozen_string_literal: true
module Api
  class HousingStatsSerializer < ActiveModel::Serializer
    type 'housing_stats'

    attributes :id,
               :requests, :provisions,
               :assigned, :remaining

    has_many :housing_requests
    has_many :housing_provisions

    def requests
      @requests ||= object.housing_requests.count
    end

    def provisions
      object.housing_provisions.map(&:housing_capacity).map(&:to_i).inject(:+) || 0
    end

    def assigned
      requests - remaining
    end

    def remaining
      @remaining ||= object.housing_requests.where(housing_provision_id: nil).count
    end
  end
end
