# frozen_string_literal: true

module Api
  module OrderOperations
    module Helpers
      def save_order
        ActiveRecord::Base.transaction do
          @model.save
          @model.order_line_items.map(&:save)
        end
      end
    end
  end
end
