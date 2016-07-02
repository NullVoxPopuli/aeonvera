class OrderSerializer < ActiveModel::Serializer
  type 'orders'

  attributes :id,
             :host_id, :host_type,
             :paid_amount, :net_amount_received, :total_fee_amount,
             :paid, :payment_method,
             :host_name, :host_url,
             :created_at, :user_email, :user_name,
             :payment_received_at,
             :total_in_cents

  # never render the payment_token

  has_many :order_line_items
  belongs_to :host
  belongs_to :attendance
  belongs_to :pricing_tier

  has_many :stripe_refunds, serializer: StripeRefundSerializer

  def total_in_cents
    # convert from dollars to cents
    (object.total * 100).to_i
  end

  def user_email
    object.buyer_email
  end

  def user_name
    object.buyer_name
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
