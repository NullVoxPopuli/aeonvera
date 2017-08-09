# frozen_string_literal: true

module Api
  class HousingStatsSerializableResource < ApplicationResource
    type 'housing-stats'

    # All of these should have 0 AR Allocations
    attribute(:requests) { @object.number_of_housing_requests }
    attribute(:provisions) { @object.number_of_housing_provisions }
    attribute(:remaiining) { @object.number_of_remaining_housing_requests }
    attribute(:assigned) { @object.number_of_fulfilled_housing_requests }

    has_many :housing_requests, class: '::Api::HousingRequestSerializableResource'
    has_many :housing_provisions, class: '::Api::HousingProvisionSerializableResource'
  end
end
