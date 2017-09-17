# frozen_string_literal: true
# == Schema Information
#
# Table name: registrations
#
#  id                          :integer          not null, primary key
#  attendee_id                 :integer
#  host_id                     :integer
#  level_id                    :integer
#  package_id                  :integer
#  pricing_tier_id             :integer
#  interested_in_volunteering  :boolean
#  needs_housing               :boolean
#  providing_housing           :boolean
#  metadata                    :text
#  checked_in_at               :datetime
#  deleted_at                  :datetime
#  created_at                  :datetime
#  updated_at                  :datetime
#  attending                   :boolean          default(TRUE), not null
#  dance_orientation           :string(255)
#  host_type                   :string(255)
#  transferred_at              :datetime
#  transfer_reason             :string
#  attendee_first_name         :string
#  attendee_last_name          :string
#  phone_number                :string
#  city                        :string
#  state                       :string
#  zip                         :string
#  transferred_from_first_name :string
#  transferred_from_last_name  :string
#  transferred_to_email        :string
#  transferred_to_year         :string
#  transferred_from_user_id    :integer
#
# Indexes
#
#  index_registrations_on_attendee_id            (attendee_id)
#  index_registrations_on_dance_orientation      (dance_orientation)
#  index_registrations_on_host_id_and_host_type  (host_id,host_type)
#  index_registrations_on_level_id               (level_id)
#

# Rules about an Registration
# - Only one unpaid order at a time
#   - if the registration owes money, there will be an unpaid order
# - Must belong to a host (Event, Organization, etc)
class Registration < ApplicationRecord
  include SoftDeletable
  include HasMetadata
  include CSVOutput

  LEAD = 'Lead'
  FOLLOW = 'Follow'

  has_one :housing_request
  has_one :housing_provision

  belongs_to :attendee, class_name: 'User'
  # TODO: remove
  belongs_to :host, -> { unscope(where: :deleted_at) }, class_name: 'Event'

  belongs_to :event, class_name: Event.name,
                     foreign_key: 'host_id'

  belongs_to :level
  belongs_to :package
  belongs_to :pricing_tier

  # for an registration, we don't care if any of our
  # references are deleted, we want to know what they were
  def attendee
    User.unscoped { super }
  end

  def package
    Package.unscoped { super }
  end

  def level
    Level.unscoped { super }
  end

  def event
    Event.unscoped { super }
  end

  has_many :custom_field_responses, as: :writer, dependent: :destroy
  has_many :orders, -> { includes(:order_line_items) }
  has_many :order_line_items, through: :orders
  has_many :purchased_items,
           through: :order_line_items,
           source: :line_item,
           inverse_of: :purchasers

  has_many :raffle_tickets,
           through: :order_line_items,
           source: :line_item,
           source_type: LineItem::RaffleTicket.name

  scope :needing_housing, -> { where(needs_housing: true) }
  scope :providing_housing, -> { where(providing_housing: true) }
  scope :volunteers, -> { where(interested_in_volunteering: true) }

  has_many :raffle_tickets,
           through: :order_line_items,
           source: :line_item,
           source_type: LineItem::RaffleTicket.name

  scope :participating_in_raffle, ->(raffle_id) {
    joins(:raffle_tickets).where("reference_id = #{raffle_id}")
  }

  scope :with_raffle_tickets, ->(raffle_id) {
    joins(:raffle_tickets).where(id: raffle_id).group('registrations.id')
  }

  scope :with_unpaid_orders, -> {
    joins(:orders).where('orders.paid != true').uniq
  }

  scope :without_orders, -> {
    joins('LEFT OUTER JOIN "orders" ON "orders"."registration_id" = "registrations"."id"')
      .where('orders.registration_id IS NULL').uniq
  }

  scope :unpaid, -> {
    joins('LEFT OUTER JOIN "orders" ON "orders"."registration_id" = "registrations"."id"')
      .where('orders.registration_id IS NULL OR orders.paid != true').uniq
  }
  #
  # scope :created_after, ->(time) { where('created_at > ?', time) }
  # scope :created_before, ->(time) { where('created_at < ?', time) }

  scope :leads, -> { where(dance_orientation: LEAD) }
  scope :follows, -> { where(dance_orientation: FOLLOW) }
  scope :volunteering, -> { where(interested_in_volunteering: true) }
  scope :checkedin, -> { where(arel_table[:checked_in_at].not_eq(nil)) }

  accepts_nested_attributes_for :custom_field_responses
  accepts_nested_attributes_for :housing_request
  accepts_nested_attributes_for :housing_provision

  # validates :pricing_tier, presence: true
  validates :event, presence: true
  # TODO: these are gross
  # validates :dance_orientation, presence: true, if: ->(a) { a.event.ask_if_leading_or_following? }
  # validates :level, presence: true, if: proc { |a| (p = a.package) && p.requires_track? }

  before_destroy :ensure_unpaid

  # for CSV output
  csv_with_columns [
    :attendee_name,
    :attendee_email,
    :package_name,
    :level_name,
    :amount_owed,
    :registered_at
  ],
                   exclude: [
                     :updated_at, :created_at,
                     :registration_id, :registration_type,
                     :id,
                     :host_id, :host_type
                   ]

  def add(object)
    send(object.class.name.demodulize.underscore.pluralize.to_s) << object
  end

  def unpaid_order
    orders.unpaid.last
  end

  def mark_orders_as_paid!(data)
    check_number = data[:check_number]
    payment_method = data[:payment_method]

    orders = self.orders.unpaid
    if orders.empty?
      new_order = self.new_order
      new_order.payment_method = payment_method
      new_order.add_check_number(check_number) if check_number
      orders = [new_order]
    end

    orders.map do |o|
      o.payment_method = payment_method
      o.paid = true
      o.paid_amount = o.total
      o.net_amount_received = o.paid_amount
      o.total_fee_amount = 0
      o.save
    end
  end

  def ordered_shirts
    result = []
    orders.each do |order|
      result = order.order_line_items.select do |li|
        li.line_item_type == LineItem::Shirt.name
      end
    end
    result = result.flatten
  end

  def attendee_email
    # TODO: add the email of the transfer person?
    if attendee
      attendee.email
    else
      metadata['email']
    end
  end

  def attendee_name
    if (first = attendee_first_name.presence) &&
        # User-less registration or
        # registering for someone else
        (last = attendee_last_name.presence)
      "#{first} #{last}"
    elsif attendee
      # normal

      # have to titleize, cause some people aren't OCD enough
      # to type their name with proper capitalization....
      attendee.name.titleize
    else
      'Name not given'
    end
  end

  def package_name
    package.try(:name)
  end

  def level_name
    level.try(:name)
  end

  def registered_at
    created_at
  end

  def amount_owed
    # later, calculate multiple orders
    if orders.present?
      orders.map { |o| o.paid? ? 0 : o.total }.inject(&:+)
    else
      0 # no orders
    end
  end

  alias remaining_balance amount_owed

  def paid_amount
    orders.present? ? orders.map { |o| o.try(:current_paid_amount) || 0 }.inject(&:+) : 0
  end

  def owes_money?
    amount_owed != 0.0
  end

  def owes_nothing?
    amount_owed == 0
  end

  def payment_status
    if owes_money?
      amount_owed
    else
      'Paid'
    end
  end

  def has_paid_orders?
    orders.where(paid: true).count > 0
  end

  def checkin!
    self.checked_in_at = Time.now
  end

  def uncheckin!
    self.checked_in_at = nil
  end

  def self.to_xls
    to_csv(col_sep: "\t")
  end

  private

  def ensure_unpaid
    return unless has_paid_orders?

    errors[:base] << 'cannot delete a registration that has paid'
    false
  end

  def purchasable_items
    result = []
    result << competitions
    result << line_items
    result << shirts
    result.flatten!
    result
  end

  # if an registration doesn't have an order, calculate things at
  # the current prices
  def total_cost
    total = 0

    total += package.current_price if package

    purchasable_items.each { |c| total += c.current_price }
    discounts.each { |d| total = d.apply_discount_to_total(total) }

    total
  end
end
