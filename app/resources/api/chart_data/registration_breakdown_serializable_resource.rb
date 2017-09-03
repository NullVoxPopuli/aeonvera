# frozen_string_literal: true

module Api
  module ChartData
    class RegistrationBreakdownSerializableResource < ApplicationResource
      type 'charts'

      attributes :root_node

      id { "#{@object.id}-registration-breakdown" }
    end
  end
end
