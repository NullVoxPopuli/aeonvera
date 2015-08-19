# object is actually an Attendance in this serializer
class OrderSerializer < ActiveModel::Serializer

  attributes :id,
    :host_id, :host_type,
    :paid_amount, :net_amount_received, :total_fee_amount,
    :paid, :payment_method,
    :host_name,
    :created_at

    def host_name
      object.host.name
    end


end
