# frozen_string_literal: true
# == Schema Information
#
# Table name: packages
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  initial_price        :decimal(, )
#  at_the_door_price    :decimal(, )
#  attendee_limit       :integer
#  expires_at           :datetime
#  requires_track       :boolean
#  event_id             :integer
#  created_at           :datetime
#  updated_at           :datetime
#  deleted_at           :datetime
#  ignore_pricing_tiers :boolean          default(FALSE), not null
#  description          :text
#
# Indexes
#
#  index_packages_on_event_id  (event_id)
#

class Package < ApplicationRecord
  include SoftDeletable
  include Purchasable

  has_many :levels
  has_many :registrations, -> {
    where(attending: true).order('registrations.created_at DESC')
  }
  belongs_to :event

  has_and_belongs_to_many :pricing_tiers,
                          join_table: 'packages_pricing_tiers',
                          association_foreign_key: 'package_id', foreign_key: 'pricing_tier_id'

  has_many :restraints, as: :restrictable
  has_many :available_discounts, through: :restraints,
                                 source: :dependable, source_type: Discount.name

  validates :event, presence: true
  validates :initial_price, presence: true
  validates :at_the_door_price, presence: true

  # @return [String] Name of this package and the current tier, if applicable
  def name_at_tier
    name
  end

  # @return [Float] current price of this package based on the current teir, if applicable
  def current_price
    if event.show_at_the_door_prices?
      at_the_door_price
    else
      event.current_tier ? price_at_tier(event.current_tier) : initial_price
    end
  end

  def price_at_tier(tier)
    if ignore_pricing_tiers
      initial_price
    else
      tier.price_of(self)
    end
  end

  def past_expiration?
    expires_at.try(:<, Time.now)
  end

  def past_attendee_limit?
    attendee_limit.try(:<=, registrations.count)
  end
end
