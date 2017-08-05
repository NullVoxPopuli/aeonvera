# frozen_string_literal: true

module Api
  class OrderSerializableResource < ApplicationResource
    type 'orders'

    BUYER_ATTRIBUTES = [
      :id,
      :is_fee_absorbed,
      :paid_amount, :total_fee_amount,
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
      :current_total_fee_amount
    ].freeze

    BUYER_RELATIONSHIPS = [:host, :order_line_items, :pricing_tier, :registration].freeze

    BUYER_FIELDS = Array[*BUYER_ATTRIBUTES, *BUYER_RELATIONSHIPS]

    attributes :is_fee_absorbed,
               :paid_amount, :net_amount_received, :total_fee_amount,
               :paid, :payment_method,
               :created_at, :user_name,
               :payment_received_at,
               :total, :sub_total,
               :check_number,
               :notes,
               :current_paid_amount,
               :current_total_fee_amount,
               :current_net_amount_received

    attribute(:stripe_refunds) do
      @object.stripe_refunds.map do |refund|
        {
          amount: refund['amount'],
          created: refund['created'],
          status: refund['status']
        }
      end
    end

    attribute(:total_in_cents) { (@object.total * 100).to_i }
    attribute(:user_email) { @object.buyer_email }
    attribute(:user_name) { @object.buyer_name }
    attribute(:host_name) { @object.host.name }
    attribute(:host_url) { @object.host.url }

    has_many :order_line_items, class: '::Api::OrderLineItemSerializableResource'
    belongs_to :host, class: { Event: '::Api::EventSerializableResource',
                               Organization: '::Api::OrganizationSerializableResource' }
    belongs_to :pricing_tier, class: '::Api::PricingTierSerializableResource'
    belongs_to :registration, class: '::Api::Users::RegistrationSerializableResource'
  end
end
