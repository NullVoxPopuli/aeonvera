# frozen_string_literal: true
# == Schema Information
#
# Table name: pricing_tiers
#
#  id                  :integer          not null, primary key
#  increase_by_dollars :decimal(, )      default(0.0)
#  date                :datetime
#  registrants         :integer
#  event_id            :integer
#  deleted_at          :datetime
#
# Indexes
#
#  index_pricing_tiers_on_event_id  (event_id)
#

class PricingTier < ApplicationRecord
  include SoftDeletable

  has_many :packages
  belongs_to :event
  has_many :registrations, -> { where(attending: true).order('registrations.created_at DESC') }
  has_many :orders

  has_and_belongs_to_many :packages,
    join_table: 'packages_pricing_tiers',
    association_foreign_key: 'pricing_tier_id', foreign_key: 'package_id'

  has_many :restraints, as: :dependable
  has_many :allowed_packages, through: :restraints,
                              source: :restrictable, source_type: Package.name

  validates :event, presence: true
  validates :date,
    allow_blank: true,
    date: {
      # after: Proc.new{ |o| o.event.registration_opens_at - 1.day },
      before: proc { |o| o.event ? o.event.ends_at : Date.today + 1000.years },
      message: :invalid_date
    }

  scope :before, ->(object) {
    if object.is_a?(PricingTier)
      table = object.class.arel_table

      where(

        # table[:date].not_eq(nil) &&
        table[:date].lt((object.date || Date.today))
      .or(
        # table[:registrants].not_eq(nil) &&
        table[:registrants].lteq(object.registrants)
      )
      )
    end
  }

  # for the provided package, calculate the current price
  # - this includes any price changes that previous tiers
  #   invoked
  def current_price(package)
    tier = event.current_tier
    (tier || self).price_of(package)
    # result = package.initial_price
    # previous_pricing_tiers.each do |pt|
    #   result += pt.amount if pt.should_apply_amount?
    # end
    #
    # result += amount if should_apply_amount?
    # result
    #
  end

  # disregards the constraints like the above method,
  # this is useful for figuring out what the price is going to be
  def price_of(package)
    result = package.initial_price

    tiers = previous_pricing_tiers(include_self: true)

    tiers.each do |pt|
      restricted_to = pt.allowed_packages

      if restricted_to.empty? || restricted_to.include?(package)
        result += pt.amount
      end
    end

    result
  end

  def should_apply_amount?
    result = false
    # account for race condition where Date.today doesn't eval to the same date
    result = true if date && date <= Date.today + 1.minute

    result = true if registrants && registrants <= event.registrations.count

    result
  end

  def amount
    increase_by_dollars || 0
  end

  def previous_pricing_tiers(include_self: false)
    tiers = event.pricing_tiers_in_order
    index = tiers.index(self) || 0
    index -= 1 unless include_self
    # return an empty array if the index is less than the starting index
    # this means that the index of this pricing tier (self)
    # is the opening tier, meaning that there are no previous tiers.
    # otherwise, return the previous tiers
    index < 0 ? [] : tiers[0..index]
  end
end
