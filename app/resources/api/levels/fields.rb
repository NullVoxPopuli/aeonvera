# frozen_string_literal: true

module Api
  module LevelFields
    PUBLIC_ATTRIBUTES = [:name, :description, :requirement].freeze

    PUBLIC_RELATIONSHIPS = [:event].freeze

    PUBLIC_FIELDS = [*PUBLIC_ATTRIBUTES, *PUBLIC_RELATIONSHIPS].freeze
  end
end
