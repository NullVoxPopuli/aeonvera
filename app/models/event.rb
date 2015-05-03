class Event < ActiveRecord::Base
  include ::EventItemHelpers
  include SoftDeletable
  include HasPaymentProcessor
  include HasDomain
  include HasLogo

  belongs_to :hosted_by, class_name: "User"
  belongs_to :user, foreign_key: :hosted_by_id

  has_many :integrations,
    :dependent => :destroy,
    :extend => Extensions::Integrations,
    as: :owner

  has_many :orders, as: :host
  has_many :attendances,
    -> { where(attending: true).order("attendances.created_at DESC") },
    as: :host, class_name: "EventAttendance"

  has_many :cancelled_attendances,
    -> { where(attending: false).order("attendances.created_at DESC") },
    as: :host, class_name: "EventAttendance"

  has_many :all_attendances,
    -> {order("attendances.created_at DESC")},
    as: :host, class_name: "Attendance"
  has_many :attendees, through: :attendances
  has_many :collaborations, as: :collaborated
  has_many :collaborators, through: :collaborations, source: :user

  has_many :packages
  has_many :passes
  has_many :discounts, as: :host
  has_many :housing_applicants
  has_many :housing_providers
  has_many :competitions
  has_many :levels
  has_many :raffles
  has_many :line_items,
    -> { where("item_type = '' OR item_type IS NULL") },
    as: :host
  has_many :shirts,
    -> { where(item_type: "LineItem::Shirt") },
    class_name: "LineItem",
    as: :host

  has_many :pricing_tiers, -> { order("date ASC") }
  has_one :opening_tier, -> { order("date ASC") }, class_name: "PricingTier"

  validates :hosted_by, presence: true
  validates :name, presence: true
  validates :ends_at, presence: true
  validates :opening_tier, presence: true

  validates :housing_status, presence: true
  validates :location, presence: true

  serialize :housing_nights

  accepts_nested_attributes_for :pricing_tiers
  accepts_nested_attributes_for :opening_tier, update_only: true, allow_destroy: true
  accepts_nested_attributes_for :packages

  HOUSING_DISABLED = 0
  HOUSING_ENABLED = 1
  HOUSING_CLOSED = 2

  SUNDAY = 0
  MONDAY = 1
  TUESDAY = 2
  WEDNESDAY = 3
  THURSDAY = 4
  FRIDAY = 5
  SATURDAY = 6

  alias_attribute :user_id, :hosted_by_id


  def registration_opens_at
    opening_tier.date
  end

  def registration_open?
    self.registration_opens_at.try(:<, Time.now)
  end

  def started?
    self.starts_at.try(:<, Time.now)
  end

  def over?
    self.ends_at.try(:<, Time.now)
  end

  def show_at_the_door_prices?
    show_at_the_door_prices_at.try(:<, Time.now)
  end

  # an event can be in two modes
  # the tiers can be by date, or by registrants
  def current_tier
    tier_table = PricingTier.arel_table

    (
      pricing_tiers.where(
        tier_table[:date].lteq(Date.today).or(
          tier_table[:registrants].lteq(
            self.attendances.count
          )
        )
      ).last || opening_tier
    )
  end
  alias_method :current_pricing_tier, :current_tier

  def pricing_tier_at(date: Date.today)
    pricing_tiers.where("date <= ?", Date.today).last or opening_tier
  end

  def allows_multiple_discounts?

  end

  def registration_json
    json = self.as_json(
      except: [:created_at, :updated_at, :expires_at, :hosted_by_id, :id, :deleted_at]
    )
    json[:packages] = {}
    packages.each do |package|
      json[:packages][package.id] = package.as_json(except: [:created_at, :updated_at, :id])
    end
    return json
  end

  def unpaid_total
    attendances.map{|a| a.amount_owed }.inject(:+)
  end

  def revenue
    preregistration_revenue + postregistration_revenue
  end

  def preregistration_revenue
    pre_orders = orders.paid.created_before(starts_at)
    pre_orders.map{ |a| a.net_received }.inject(:+) || 0
  end

  def postregistration_revenue
    pre_orders = orders.paid.created_after(starts_at)
    pre_orders.map{ |a| a.net_received }.inject(:+) || 0
  end

  def shirts_sold
    self.attendances.with_shirts.count.inject(0){|total, element| total += element[1]}
  end

  def shirts_available?
    !self.shirt_sales_end_at || self.shirt_sales_end_at > Time.now
  end

end
