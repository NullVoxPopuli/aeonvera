class PackageSerializer < ActiveModel::Serializer

  attributes :id, :name,
    :initial_price, :at_the_door_price,
    :attendee_limit,
    :expires_at,
    :requires_track,
    :event_id,
    :ignore_pricing_tiers,
    :number_of_leads,
    :number_of_follows

  belongs_to :event

  def number_of_leads
    object.attendances.leads.count
  end

  def number_of_follows
    object.attendances.follows.count
  end
end
