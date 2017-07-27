# frozen_string_literal: true
# == Schema Information
#
# Table name: orders
#
#  id                          :integer          not null, primary key
#  payment_token               :string(255)
#  payer_id                    :string(255)
#  metadata                    :text
#  attendance_id               :integer
#  host_id                     :integer
#  created_at                  :datetime
#  updated_at                  :datetime
#  paid                        :boolean          default(FALSE), not null
#  payment_method              :string(255)      default("Cash"), not null
#  paid_amount                 :decimal(, )
#  net_amount_received         :decimal(, )      default(0.0), not null
#  total_fee_amount            :decimal(, )      default(0.0), not null
#  user_id                     :integer
#  host_type                   :string(255)
#  payment_received_at         :datetime
#  pricing_tier_id             :integer
#  current_paid_amount         :decimal(, )      default(0.0), not null
#  current_net_amount_received :decimal(, )      default(0.0), not null
#  current_total_fee_amount    :decimal(, )      default(0.0), not null
#  created_by_id               :integer
#  is_fee_absorbed             :boolean          default(TRUE)
#
# Indexes
#
#  index_orders_on_created_by_id          (created_by_id)
#  index_orders_on_host_id_and_host_type  (host_id,host_type)
#  index_orders_on_pricing_tier_id        (pricing_tier_id)
#  index_orders_on_user_id                (user_id)
#

class Order < ApplicationRecord
  # default_scope do
  #   includes(
  #     :user, :registration, :pricing_tier,
  #     order_line_items: [:line_item]
  #   )
  # end

  # Active Metadata keys:
  # - email
  # - user
  # - details
  include HasMetadata
  include StripePaymentHandler
  include StripeData
  include Payable
  include OrderMembership

  belongs_to :host, -> { unscope(where: :deleted_at) }, polymorphic: true
  belongs_to :event, class_name: Event.name,
                     foreign_key: 'host_id', foreign_type: 'host_type', polymorphic: true

  belongs_to :registration
  # A user is always going to be the person paying.
  # and should always be the same as the user that attendance is attached to.
  belongs_to :user
  belongs_to :created_by, class_name: User.name

  belongs_to :pricing_tier

  has_many :order_line_items, dependent: :destroy, inverse_of: :order

  # This has many doesn't work due to the line_item
  # relationship being polymorphic. Rails doesn't want to return
  # an association of mixed types (understandably)
  # has_many :line_items,
  #          through: :order_line_items,
  #          source: :line_item,
  #          inverse_of: :orders
  #
  # this could be expensive :-\
  def line_items
    order_line_items.includes(:line_item).map(&:line_item).flatten.uniq
  end

  accepts_nested_attributes_for :order_line_items
  accepts_nested_attributes_for :registration

  scope :unpaid, -> { where(paid: false) }
  scope :paid, -> { where(paid: true) }
  scope :created_after, ->(time) { where('orders.created_at > ?', time) }
  scope :created_before, ->(time) { where('orders.created_at < ?', time) }
  scope :order_line_items_line_item_id_eq, ->(value) {
    joins(:order_line_items).where(order_line_items: { line_item_id: value })
  }
  scope :order_line_items_line_item_type_like, ->(value) {
    joins(:order_line_items).where('order_line_items.line_item_type LIKE ?', "%#{value}%")
  }

  validates :buyer_email, presence: true
  validates :buyer_name, presence: true
  validates :host, presence: true
  validate :require_attendance_if_has_competitions

  before_create do |instance|
    # Set is_fee_absorbed to whatever the event is set to.
    # This will require an update to to make the order different
    # from the event / org.
    # NOTE: that kind of change must be authorized by an owner/collaborator
    #
    # Order defaults to true
    # - Scenario 1:
    #   Order absorbs fees, Event does not
    # - Scenario 2:
    #   Order absorbs fees, Event also does
    # - Scenario 3:
    #   Order does not absorb fees, Event does not
    # - Scenario 4:
    #   Order does not absorb fees, Event does.
    instance.is_fee_absorbed = !host.make_attendees_pay_fees? if host
    true
  end

  before_save do |instance|
    instance.sync_current_payment_aggregations
    # before filter must return true to continue saving.
    # the above two checks do not halt saving, nor do they
    # create a bad state
    true
  end

  def self.ransackable_scopes(auth_object = nil)
    [:order_line_items_line_item_id_eq, :order_line_items_line_item_type_like]
  end

  def is_accessible_to?(someone)
    return true if someone == user
    return true if user.hosted_events.include?(event)
    return true if user.collaborated_events.include?(event)

    false
  end

  def require_attendance_if_has_competitions
    return true unless has_competition?

    unless (name_from_metadata || attendance.try(:attendee_name)) &&
        (email_from_metadata || attendance.try(:attendee_email))
      errors.add(:base, 'Registrant attendance or buyer name and email are required when purchasing a competition.')
    end
  end

  # There cannot be multiple results.
  # that's why where is quantity.
  def order_line_item_for_item(line_item)
    order_line_item_for(line_item.id, line_item.class.name)
  end

  def order_line_item_for(line_item_id, line_item_type)
    order_line_items.select do |oli|
      oli.line_item_id == line_item_id &&
        oli.line_item_type == line_item_type
    end.first
  end

  def has_competition?
    order_line_items.select { |oli| oli.line_item_type == Competition.name }.present?
  end

  def buyer_name
    name_from_metadata || attendance.try(:attendee_name) || user.try(:name) || created_by.try(:name)
  end

  def buyer_email
    email_from_metadata || attendance.try(:attendee_email) || user.try(:email) || created_by.try(:email)
  end

  # TODO: do I want these to actually be fields?
  #
  # This is an optional field, the email is normally retrieved from the user
  def buyer_email=(email)
    metadata['email'] = email
  end

  # TODO: do I want these to actually be fields?
  #
  # This is an optional field, the email is normally retrieved from the user
  def buyer_name=(name)
    metadata['name'] = name
  end

  def notes
    metadata['notes']
  end

  def notes=(new_notes)
    metadata['notes'] = new_notes
  end

  def email_from_metadata
    metadata['email']
  end

  def name_from_metadata
    metadata['name']
  end

  # short hand for setting a field on the metadata
  def set_payment_details(details)
    metadata['details'] = details
  end

  def force_paid!
    self.paid = true
    save
  end

  def owes
    paid? ? 0 : total
  end

  def save_payment_errors(errors)
    metadata[:errors] = errors
    save
  end

  # ideally, this is ran upon successful payment
  def set_net_amount_received_and_fees
    if payment_method == Payable::Methods::STRIPE || payment_method == Payable::Methods::CREDIT
      set_net_amount_received_and_fees_from_stripe
    end
  end

  def belongs_to_organization?
    host_type == Organization.name
  end

  def has_membership?
    order_line_items.select do |line_item|
      line_item.line_item_type == LineItem::MembershipOption.name
    end.present?
  end

  # Sets the non-stripe payment information.
  # paid_amount, and net_amount_received are
  # set from the amount passed in.
  #
  # TODO: will this ever make sense to set
  #       electronic payment information on?
  #
  # data should contain:
  # - payment_method
  # - amount
  # - check_number
  #
  # @param [Hash] data
  def mark_paid!(data)
    # we cannot change payment information
    # at least, we'd want to really be sure
    # and have some sort of administrative
    # override
    return if paid?

    params = {
      paid: true,
      check_number:        data[:check_number],
      payment_method:      data[:payment_method] || Payable::Methods::CASH,
      paid_amount:         data[:amount] || paid_amount || 0,
      net_amount_received: data[:amount] || net_amount_received || 0,
      notes:               data[:notes],
      payment_received_at: Time.now
    }

    update(params)
  end

  def sync_current_payment_aggregations
    StripeTasks::RefreshCharge.update_current_amounts(self)
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ['Name', 'Email', 'Registered At', 'Payment Method', 'Paid',
              'Total Fees', 'Net Received', 'Line Items']
      all.each do |order|
        order_user = order.user
        order_attendee = order.attendance

        line_item_list = order.order_line_items.map do |i|
          "#{i.quantity} x #{i.name} @ #{i.price}"
        end.join(', ')

        row = [
          order_user.try(:name) || order_attendee.try(:attendee_name) || 'Unknown',
          order_user.try(:email) || order_attendee.try(:attendee_name) || 'Unknown',
          order.created_at,
          order.payment_method,
          order.paid_amount,
          order.total_fee_amount,
          order.net_amount_received,
          line_item_list
        ]
        csv << row
      end
    end
  end
end
