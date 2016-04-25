module OrderOperations
  module Helpers

    def save_order
      ActiveRecord::Base.transaction do
        @model.save
        @model.line_items.map(&:save)
      end
    end
  end
end
