module PublicAttributes
  module PricingTierAttributes
    extend ActiveSupport::Concern

    included do
      attributes :id, :event_id,
        :increase_by, :date, :registrants,
        :is_opening_tier
    end

    def increase_by
      object.amount
    end

    def is_opening_tier
      object == object.event.opening_tier
    end
  end
end
