class AttendanceSerializer < ActiveModel::Serializer

  attributes :id,
    :attendee_name, :dance_orientation,
    :amount_owed, :amount_paid, :registered_at,
    :package_name, :level_name,
    :event_id

  def amount_paid
    object.paid_amount
  end

  def registered_at
    object.created_at
  end

  def package_name
    object.try(:package).try(:name)
  end

  def level_name
    object.try(:level).try(:name)
  end

  def event_id
    object.host_id
  end

end
