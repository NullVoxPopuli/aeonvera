# frozen_string_literal: true

module Api
  class MembershipOptionSerializableResource < ApplicationResource
    type 'membership-options'

    attributes :duration_in_words,
               :name, :price,
               :starts_at, :ends_at, :schedule,
               :duration_amount, :duration_unit,
               :registration_opens_at, :registration_closes_at,
               :description,
               :expires_at

    # attribute(:number_purchased) { @object.order_line_items.count }
    attribute(:current_price) { @object.price }
  end
end
