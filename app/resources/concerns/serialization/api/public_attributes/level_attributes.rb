# frozen_string_literal: true
module Api
  module PublicAttributes
    module LevelAttributes
      extend ActiveSupport::Concern

      included do
        attributes :id, :event_id,
          :name, :description,
          :requirement, :deleted_at
      end
    end
  end
end
