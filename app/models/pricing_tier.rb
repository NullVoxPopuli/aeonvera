class PricingTier < ActiveRecord::Base
  include SoftDeletable

  has_many :packages
  belongs_to :event
  has_many :attendances, -> { where(attending: true).order("attendances.created_at DESC") }


  has_and_belongs_to_many :packages,
    join_table: "packages_pricing_tiers",
    association_foreign_key: "pricing_tier_id", foreign_key: "package_id"

  has_many :restraints, as: :dependable
  has_many :allowed_packages, through: :restraints,
    source: :restrictable, source_type: Package.name

  validate :event, presence: true
  validates :date,
    allow_blank: true,
  date: {
    # after: Proc.new{ |o| o.event.registration_opens_at - 1.day },
    before: Proc.new{ |o| o.event ? o.event.ends_at : Date.today + 1000.years },
    message: :invalid_date
  }

  scope :before, ->(object){
    if object.is_a?(PricingTier)
      table = object.class.arel_table
      attendance_table = Attendance.arel_table

      where(
        (
          # table[:date].not_eq(nil) &&
          table[:date].lt((object.date || Date.today))
        ).or(
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
    # tier = event.current_tier
    # (tier || self).price_of(package)
    result = package.initial_price
    previous_pricing_tiers.each do |pt|
      result += pt.amount
    end

    result += amount if should_apply_amount?
    result

  end

  # disregards the constraints like the above method,
  # this is useful for figuring out what the price is going to be
  def price_of(package)
    result = package.initial_price

    if allowed_packages.empty? or allowed_packages.include?(package)
      (event.pricing_tiers).each do |pt|
        result += pt.amount if pt.should_apply_amount?
      end
    end
    result
  end


  def should_apply_amount?
    result = false
    # account for race condition where Date.today doesn't eval to the same date
    if date && date <= Date.today + 1.minute
      result = true
    end

    if registrants && registrants <= event.attendances.count
      result = true
    end

    return result
  end

  def amount
    increase_by_dollars || 0
  end

  def previous_pricing_tiers
    event.pricing_tiers.before(self)
  end

end
