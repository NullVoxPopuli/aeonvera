# object is actually an Attendance in this serializer
class OrderSerializer < ActiveModel::Serializer

  attributes :id,
    :host_id, :host_type,
    :paid_amount, :net_amount_received, :total_fee_amount,
    :paid, :payment_method,
    :host_name, :host_url,
    :created_at, :user_email,
    :total_in_cents

    def total_in_cents
      # convert from dollars to cents
      object.total * 100
    end

    def user_email
      # will also check meta data in case of non-user-bount attendance
      object.attendance.attendee_email
    end

    def host_name
      object.host.name
    end

    def host_url
      object.host.url
    end


end
