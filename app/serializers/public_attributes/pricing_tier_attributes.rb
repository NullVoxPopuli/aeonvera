module PublicAttributes
  module PricingTierAttributes
    extend ActiveSupport::Concern

    included do
      attributes :id, :event_id,
        :increase_by, :increase_after_date,
        :increase_after_total_registrants,
        :is_opening_tier
    end

    def increase_by
      object.amount
    end

    def increase_after_date
      object.date
    end

    def increase_after_total_registrants
      object.registrants
    end
    
    def is_opening_tier
      object == object.event.opening_tier
    end
  end
end
