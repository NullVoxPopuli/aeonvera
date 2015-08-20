# object is actually an Attendance in this serializer
class RegisteredEventSerializer < ActiveModel::Serializer

  attributes :id, :name, :registered_at,
    :amount_owed, :amount_paid,
    :event_begins_at, :is_attending,
    :url

  def is_attending
    object.attending?
  end

  def event_begins_at
    object.event.starts_at
  end

  def amount_paid
    object.orders.where(paid: true).map(&:paid_amount).compact.sum
  end

  def amount_owed
    object.amount_owed || 0
  end

  def registered_at
    object.created_at
  end

  def name
    object.event.name
  end

  def url
    object.host.url
  end

end
