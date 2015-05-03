class Package < ActiveRecord::Base
  include SoftDeletable

  has_many :levels
  has_many :attendances, -> { where(attending: true).order("attendances.created_at DESC") }
  belongs_to :event

  has_and_belongs_to_many :pricing_tiers,
    join_table: "packages_pricing_tiers",
    association_foreign_key: "package_id", foreign_key: "pricing_tier_id"

  has_many :restraints, as: :restrictable
  has_many :available_discounts, through: :restraints,
    source: :dependable, source_type: Discount.name

  scope :with_attendances, joins(:attendances).group("package_id")

  validate :event, presence: true

  # @return [String] Name of this package and the current tier, if applicable
  def name_at_tier
    self.name
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
    self.expires_at.try(:<, Time.now)
  end

  def past_attendee_limit?
    self.attendee_limit.try(:<=, self.attendances.count)
  end


end
