class AttendanceSerializer < ActiveModel::Serializer

  attributes :id,
    :attendee_name, :dance_orientation,
    :amount_owed, :amount_paid, :registered_at,
    :checked_in_at, :is_checked_in,
    :package_name, :level_name,
    :event_id, :level_id,
    :interested_in_volunteering

  has_many :orders
  belongs_to :host
  belongs_to :attendee

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

  def is_checked_in
    !!object.checked_in_at
  end

  def event_id
    object.host_id
  end

end
