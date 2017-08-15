# frozen_string_literal: true

module Api
  class HousingStatsPresenter
    attr_reader :event

    delegate :id, :housing_requests, :housing_provisions,
             to: :event

    def initialize(event)
      @event = event
    end

    def number_of_housing_requests
      @num_housing_requests ||= housing_requests.count(:id)
    end

    def number_of_housing_provisions
      @num_housing_provisions ||= housing_provisions.pluck(:housing_capacity).sum || 0
    end

    def number_of_fulfilled_housing_requests
      @number_of_fulfilled_housing_requests ||= begin
        housing_provision_id = HousingRequest.arel_table[:housing_provision_id]

        housing_requests.where(housing_provision_id.not_eq(nil)).count(:id)
      end
    end

    def number_of_remaining_housing_requests
      @num_remaining_housing_requests ||= housing_requests.where(housing_provision_id: nil).count(:id)
    end
  end
end
