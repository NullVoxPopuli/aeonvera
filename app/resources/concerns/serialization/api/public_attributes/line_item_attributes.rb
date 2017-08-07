# frozen_string_literal: true
module Api
  module PublicAttributes
    module LineItemAttributes
      extend ActiveSupport::Concern

      included do
        attributes :id,
                   :name, :current_price, :price,
 :number_purchased,
                   :starts_at, :ends_at, :schedule,
                   :duration_amount, :duration_unit,
                   :registration_opens_at, :registration_closes_at,
                   :description,
                   :expires_at

        belongs_to :host
      end

      def number_purchased
        object.order_line_items.count
      end

    end
  end
end
