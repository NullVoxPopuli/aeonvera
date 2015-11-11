class OrderSerializer < ActiveModel::Serializer

  attributes :id,
    :host_id, :host_type,
    :paid_amount, :net_amount_received, :total_fee_amount,
    :paid, :payment_method,
    :host_name, :host_url,
    :created_at, :user_email,
    :payment_received_at,
    :total_in_cents

  has_many :order_line_items

  def order_line_items
    object.line_items
  end

  def total_in_cents
    # convert from dollars to cents
    object.total * 100
  end

  def user_email
    # will also check meta data in case of non-user-bount attendance
    object.user.try(:email) || object.attendance.try(:attendee_email)
  end

  def host_name
    object.host.name
  end

  def host_type
    if object.host_type == 'Organization'
      'Community'
    else
      object.host_type
    end
  end

  def host_url
    object.host.url
  end


end
