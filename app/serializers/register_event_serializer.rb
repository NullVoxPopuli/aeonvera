class RegisterEventSerializer < EventSerializer
  class PackageSerializer < ActiveModel::Serializer
      attributes :id, :name,
        :initial_price, :at_the_door_price,
        :attendee_limit,
        :expires_at,
        :requires_track,
        :event_id,
        :ignore_pricing_tiers,
        :current_price

      belongs_to :event
  end
end
