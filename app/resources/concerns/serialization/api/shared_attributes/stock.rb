# frozen_string_literal: true

module Api
  module SharedAttributes
    module Stock
      extend ActiveSupport::Concern

      included do
        attributes :initial_stock

        attribute(:remaining_stock) { @object.initial_stock - @object.order_line_items.size}
        attribute(:number_purchased) { @object.order_line_items.size }
      end
    end
  end
end
