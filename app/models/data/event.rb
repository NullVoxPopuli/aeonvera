# frozen_string_literal: true
# == Schema Information
#
# Table name: events
#
#  id                              :integer          not null, primary key
#  name                            :string(255)      not null
#  short_description               :string(255)
#  domain                          :string(255)      not null
#  starts_at                       :datetime         not null
#  ends_at                         :datetime         not null
#  mail_payments_end_at            :datetime
#  electronic_payments_end_at      :datetime
#  refunds_end_at                  :datetime
#  has_volunteers                  :boolean          default(FALSE), not null
#  volunteer_description           :string(255)
#  housing_status                  :integer          default(0), not null
#  housing_nights                  :string(255)      default("5,6")
#  hosted_by_id                    :integer
#  deleted_at                      :datetime
#  created_at                      :datetime
#  updated_at                      :datetime
#  allow_discounts                 :boolean          default(TRUE), not null
#  payment_email                   :string(255)      default(""), not null
#  beta                            :boolean          default(FALSE), not null
#  shirt_sales_end_at              :datetime
#  show_at_the_door_prices_at      :datetime
#  allow_combined_discounts        :boolean          default(TRUE), not null
#  location                        :string(255)
#  show_on_public_calendar         :boolean          default(TRUE), not null
#  make_attendees_pay_fees         :boolean          default(TRUE), not null
#  accept_only_electronic_payments :boolean          default(FALSE), not null
#  logo_file_name                  :string(255)
#  logo_content_type               :string(255)
#  logo_file_size                  :integer
#  logo_updated_at                 :datetime
#  registration_email_disclaimer   :text
#  legacy_housing                  :boolean          default(FALSE), not null
#  ask_if_leading_or_following     :boolean          default(TRUE), not null
#  contact_email                   :string
#  online_competition_sales_end_at :datetime
#
# Indexes
#
#  index_events_on_domain  (domain)
#

class Event < ApplicationRecord
  include SoftDeletable
  include HasPaymentProcessor
  include HasDomain
  include HasLogo

  # aliases, cause I keep forgetting which is what
  belongs_to :hosted_by, class_name: 'User'
  belongs_to :user, foreign_key: :hosted_by_id
  has_many :sponsorships, as: :sponsored
  has_many :sponsoring_organizations, through: :sponsorships,
                                      source: :sponsor,
                                      source_type: Organization.name

  has_many :integrations,
           dependent: :destroy,
           extend: Extensions::Integrations,
           as: :owner

  has_many :notes, as: :host
  has_many :custom_fields, as: :host
  has_many :orders, as: :host
  has_many :order_line_items, through: :orders, source: :order_line_items

  has_many :registrations,
           -> { where(attending: true).order('registrations.created_at DESC') },
           foreign_key: :host_id, class_name: 'Registration'

  has_many :cancelled_registrations,
           -> { where(attending: false).order('registrations.created_at DESC') },
           as: :host, class_name: 'Registration'

  has_many :attendees, through: :registrations
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
           -> { where(item_type: 'LineItem::Shirt') },
           class_name: 'LineItem',
           as: :host

  # this way of sorting pricing ties does not put the opening tier in
  # the correct spot. That is fixed with a method
  # pricing_tiers_in_order
  has_many :pricing_tiers, -> { order('registrants ASC, date ASC') }
  has_one :opening_tier, -> { order('id ASC') }, class_name: 'PricingTier'

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

    now = Time.now

    Event.where(show_on_public_calendar: true)
         .where(ends_at.gt(now))
         .order(table[:ends_at].asc)
  end

  def recent_registrations
    registrations.limit(5).order('created_at DESC')
  end

  def registration_opens_at
    opening_tier.date
  end

  def registration_open?
    registration_opens_at.try(:<, Time.now)
  end

  def started?
    starts_at.try(:<, Time.now)
  end

  def over?
    ends_at.try(:<, Time.now)
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

  alias current_pricing_tier current_tier

  def active_tiers
    @active_tiers ||= pricing_tiers_in_order.select(&:should_apply_amount?)
  end

  def pricing_tier_at(date: Date.today)
    pricing_tiers.where('date <= ?', date).last || opening_tier
  end

  def pricing_tiers_in_order
    unless @pricing_tiers_in_order
      # opening tier should be first
      opening_tier = self.opening_tier
      # pricing tiers should already be sorted by
      # - registrants ASC
      # - date ASC
      tiers = pricing_tiers.to_a.keep_if { |t| t.id != opening_tier.id }
      tiers = [opening_tier] + tiers
      @pricing_tiers_in_order = tiers
    end

    @pricing_tiers_in_order
  end

  def allows_multiple_discounts?
  end

  def registration_json
    json = as_json(
      except: [:created_at, :updated_at, :expires_at, :hosted_by_id, :id, :deleted_at]
    )
    json[:packages] = {}
    packages.each do |package|
      json[:packages][package.id] = package.as_json(except: [:created_at, :updated_at, :id])
    end
    json
  end

  def unpaid_total
    registrations.map(&:amount_owed).inject(:+)
  end

  def revenue
    preregistration_revenue + postregistration_revenue
  end

  def preregistration_revenue
    pre_orders = orders.paid.created_before(starts_at)
    pre_orders.map(&:current_net_amount_received).inject(:+) || 0
  end

  def postregistration_revenue
    pre_orders = orders.paid.created_after(starts_at)
    pre_orders.map(&:current_net_amount_received).inject(:+) || 0
  end

  def shirts_sold
    order_ids = orders.paid.pluck(:id)

    OrderLineItem
      .where(line_item_type: LineItem::Shirt.name, order_id: order_ids)
      .pluck(:quantity)
      .sum
  end

  def shirts_available?
    !shirt_sales_end_at || shirt_sales_end_at > Time.now
  end

  def is_accessible_to?(user)
    return false unless user
    return true if hosted_by == user
    return true if user.attended_event_ids.include?(id)
    return true if user.collaborated_event_ids.include?(id)

    false
  end

  # a higher level of access
  def is_accessible_as_collaborator?(user)
    return false unless user
    return true if hosted_by == user
    return true if user.collaborated_event_ids&.include?(id)

    false
  end
end
