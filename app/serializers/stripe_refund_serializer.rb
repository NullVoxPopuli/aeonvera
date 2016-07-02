class StripeRefundSerializer < ActiveModel::Serializer
  type 'stripe-refund'

  attributes :id,
    :amount, :created, :status
end
