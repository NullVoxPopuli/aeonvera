# frozen_string_literal: true
module Api
  class OrderSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    type 'order'

    attributes :id,
      :host_id, :host_type,
      :is_fee_absorbed,
      :paid_amount, :net_amount_received, :total_fee_amount,
      :paid, :payment_method,
      :host_name, :host_url,
      :created_at, :user_email, :user_name,
      :payment_received_at,
      :total_in_cents,
      :total, :sub_total,
      :check_number,
      :notes,
      :stripe_refunds,
      :current_paid_amount,
      :current_total_fee_amount,
      :current_net_amount_received

    # never render the payment_token

    has_many :order_line_items do
      link(:related) { href api_order_order_line_items_path(order_id: object.id) }
      include_data true
      object.order_line_items.loaded? ? object.order_line_items : OrderLineItem.none
    end
    belongs_to :host
    belongs_to :attendance
    belongs_to :pricing_tier

    def stripe_refunds
      object.stripe_refunds.map do |refund|
        {
          amount: refund['amount'],
          created: refund['created'],
          status: refund['status']
        }
      end
    end

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

    def host_url
      object.host.url
    end
  end
end
