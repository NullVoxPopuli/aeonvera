# frozen_string_literal: true

module Api
  module PublicAttributes
    module PricingTierAttributes
      extend ActiveSupport::Concern

      included do
        attributes :id, :event_id,
                   :increase_by_dollars, :date, :registrants,
                   :is_opening_tier
      end

      def is_opening_tier
        object == object.event.opening_tier
      end
    end
  end
end
