class VolunteerSerializer < ActiveModel::Serializer
  type 'volunteers'
  attributes :id,
    :attendee_name, :attendee_email,
    :amount_owed, :amount_paid, :registered_at,
    :checked_in_at,
    :event_id, :phone_number

  # TODO: it would be great to have the unpaid order sideloaded here
  # but AMS struggles with nested serialization

  def phone_number
    object.metadata['phone_number']
  end


  def amount_paid
    object.paid_amount
  end

  def event_id
    object.host_id
  end

end
