# frozen_string_literal: true

module Api
  class OrderSerializableResource < ApplicationResource
    type 'orders'

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

    attribute(:total_in_cents) do
      # convert from dollars to cents
      (@object.total * 100).to_i
    end

    attribute(:user_email) do
      @object.buyer_email
    end

    attribute(:user_name) do
      @object.buyer_name
    end

    attribute(:host_name) do
      @object.host.name
    end

    attribute(:host_url) do
      @object.host.url
    end

    has_many :order_line_items, class: '::Api::OrderLineItemSerializableResource'
    belongs_to :host, class: { Event: '::Api::EventSerializableResource',
                               Organization: '::Api::OrganizationSerializableResource' }
    belongs_to :pricing_tier, class: '::Api::PricingTierSerializableResource'
    belongs_to :registration, class: '::Api::Users::RegistrationSerializableResource'
  end
end
