class PricingTierSerializer < ActiveModel::Serializer

  attributes :id, :event_id,
    :increase_by, :increase_after_date,
    :increase_after_total_registrants,
    :number_of_leads, :number_of_follows

    def number_of_follows
      object.attendances.follows.count
    end

    def number_of_leads
      object.attendances.leads.count
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
end
