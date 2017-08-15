# frozen_string_literal: true

module Api
  module SharedAttributes
    module HasOrderLineItems
      extend ActiveSupport::Concern

      included do
        # attribute(:number_of_leads) { @object.order_line_items.leads.count }
        # attribute(:number_of_follows) { @object.order_line_items.follows.count }
        attribute(:number_of_registrants) { @object.order_line_items.count }
      end
    end
  end
end
