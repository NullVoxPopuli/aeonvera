class Event < ActiveRecord::Base
  include ::EventItemHelpers
  include SoftDeletable
  include HasPaymentProcessor
  include HasDomain
  include HasLogo

  # aliases, cause I keep forgetting which is what
  belongs_to :hosted_by, class_name: "User"
  belongs_to :user, foreign_key: :hosted_by_id
  has_many :sponsorships, as: :sponsored
  has_many :sponsoring_organizations, through: :sponsorships,
    source: :sponsor,
    source_type: Organization.name

  has_many :integrations,
    :dependent => :destroy,
    :extend => Extensions::Integrations,
    as: :owner


  has_many :custom_fields, as: :host
  has_many :orders, as: :host

  has_many :attendances,
    -> { where(attending: true).order("attendances.created_at DESC") },
    as: :host, class_name: "EventAttendance"

  alias_method :event_attendances, :attendances

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
  has_many :housing_provisions, as: :host
  has_many :housing_requests, as: :host
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

  # this way of sorting pricing ties does not put the opening tier in
  # the correct spot. That is fixed with a method
  # pricing_tiers_in_order
  has_many :pricing_tiers, -> { order("registrants ASC, date ASC") }
  has_one :opening_tier, -> { order("id ASC") }, class_name: "PricingTier"

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

  # Finds all events that are allowed to be shown on the
  # public calendar, and that have not ended
  #
  # @return [Array<Event>] list of events that have registration
  #   available in the future
  def self.upcoming
    table = Event.arel_table
    ends_at = table[:ends_at]
    event_id = table[:id]

    opening_date = PricingTier.arel_table[:date]
    now = Time.now

    Event.where(show_on_public_calendar: true).
      where(ends_at.gt(now)).
      order(table[:ends_at].asc)
  end

  def recent_registrations
    self.attendances.limit(5).order("created_at DESC")
  end

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
    unless @current_tier
      tiers = pricing_tiers_in_order
      # should be the most recent active tier
      @current_tier = active_tiers.last

      # if the current_tier is still undefined, set to the
      # opening tier
      @current_tier ||= tiers.first
    end

    @current_tier
  end

  alias_method :current_pricing_tier, :current_tier

  def active_tiers
    @active_tiers ||= pricing_tiers_in_order.select{ |t|
      t.should_apply_amount?
    }
  end


  def pricing_tier_at(date: Date.today)
    pricing_tiers.where("date <= ?", Date.today).last or opening_tier
  end

  def pricing_tiers_in_order
    unless @pricing_tiers_in_order
      # opening tier should be first
      opening_tier = self.opening_tier
      # pricing tiers should already be sorted by
      # - registrants ASC
      # - date ASC
      tiers = self.pricing_tiers.to_a.keep_if{ |t| t.id != opening_tier.id }
      tiers = [opening_tier] + tiers
      @pricing_tiers_in_order = tiers
    end

    @pricing_tiers_in_order
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
    pre_orders.map{ |a| a.current_net_amount_received }.inject(:+) || 0
  end

  def postregistration_revenue
    pre_orders = orders.paid.created_after(starts_at)
    pre_orders.map{ |a| a.current_net_amount_received }.inject(:+) || 0
  end

  def shirts_sold
    orders
      .paid
      .joins(:order_line_items)
      .where(order_line_items: { line_item_type: LineItem::Shirt.name })
      .map(&:order_line_items).flatten
      .inject(0){ |total, oli| total + oli.quantity }
  end

  def shirts_available?
    !self.shirt_sales_end_at || self.shirt_sales_end_at > Time.now
  end

  def is_accessible_to?(user)
    return false unless user
    return true if self.hosted_by == user
    return true if user.attended_event_ids.include?(self.id)
    return true if user.collaborated_event_ids.include?(self.id)

    false
  end

  # a higher level of access
  def is_accessible_as_collaborator?(user)
    return false unless user
    return true if self.hosted_by == user
    return true if user.collaborated_event_ids.include?(self.id)

    false
  end

end
