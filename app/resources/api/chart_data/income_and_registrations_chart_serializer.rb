# frozen_string_literal: true

module Api
  module ChartData
    class IncomeAndRegistrationsChartSerializableResource < ApplicationResource
      type 'charts'

      id { "#{@object.id}-income-and-registrations" }

      attributes :incomes, :registrations,
                 :income_times,
                 :registration_times
    end
  end
end
