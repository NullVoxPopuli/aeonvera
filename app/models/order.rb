class Order < ActiveRecord::Base
  # Active Metadata keys:
  # - email
  # - user
  # - details
  include HasMetadata
  include StripePaymentHandler
  include StripeData
  include Payable
  include OrderMembership

  belongs_to :host, polymorphic: true
	belongs_to :event, class_name: Event.name,
	 foreign_key: "host_id", foreign_type: "host_type", polymorphic: true

  belongs_to :attendance
  # A user is always going to be the person paying.
  # and should always be the same as the user that attendance is attached to.
  belongs_to :user

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
  accepts_nested_attributes_for :attendance

  scope :unpaid, -> { where(paid: false) }
  scope :paid, -> {where(paid: true)}
  scope :created_after, ->(time){ where("orders.created_at > ?", time) }
  scope :created_before, ->(time){ where("orders.created_at < ?", time) }


  validates :buyer_email, presence: true
  validates :buyer_name, presence: true
  validates :host, presence: true
  validates :attendance, presence: true, if: 'host_type=="Event"'

  before_save do |instance|
    instance.check_paid_status
    # before filter must return true to continue saving.
    # the above two checks do not halt saving, nor do they
    # create a bad state
    true
  end

  def is_accessible_to?(someone)
    return true if someone == user
    return true if user.hosted_events.include?(event)
    return true if user.collaborated_events.include?(event)

    false
  end

  def buyer_name
    name_from_metadata || attendance.try(:attendee_name) || user.try(:name)
  end

  def buyer_email
    email_from_metadata || attendance.try(:attendee_email) || user.try(:email)
  end

  # TODO: do I want these to actually be fields?
  #
  # This is an optional field, the email is normally retrieved from the user
  def buyer_email=(email)
    self.metadata['email'] = email
  end

  # TODO: do I want these to actually be fields?
  #
  # This is an optional field, the email is normally retrieved from the user
  def buyer_name=(name)
    self.metadata['name'] = name
  end

  def email_from_metadata
    self.metadata['email']
  end

  def name_from_metadata
    self.metadata['name']
  end

  # short hand for setting a field on the metadata
  def set_payment_details(details)
    self.metadata["details"] = details
  end

  def force_paid!
    self.paid = true
    self.save
  end

  def owes
    paid? ? 0 : total
  end

  def save_payment_errors(errors)
    self.metadata[:errors] = errors
    self.save
  end

  # ideally, this is ran upon successful payment
  def set_net_amount_received_and_fees
    if self.payment_method == Payable::Methods::STRIPE || self.payment_method == Payable::Methods::CREDIT
      set_net_amount_received_and_fees_from_stripe
    end
  end


  # TODO: this logic sucks, find a better way
  # Scenarios:
  # Total is 0
  #  - automatically mark paid
  # Total is not 0
  #  - should not be paid, unless paid amount matches total
  def check_paid_status
    # if we don't owe anything
    # - can happen on new record
    # - can happen if paid
    if self.total == 0.0
      # set to paid
      self.payer_id = "0"
      self.paid = true

      # if the paid amount is /still/ nil
      if self.paid_amount == nil
        # set the paid amount to 0.0, since the total is 0.0
        self.paid_amount = 0.0
      end
    elsif self.total > 0 && self.paid_amount == 0.0
      # this happens when total amount has changed
      # (adding a line item when a package of 0 cost has been
      # previously added)
      self.paid = false
      self.paid_amount = nil
    elsif self.paid_amount.nil?
      # money is owed, the order has not been paid
      self.paid = false
    end

    if self.paid == true && paid_amount == nil && self.total == 0.0
      self.paid = false
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
    return unless paid?

    params = {
      paid: true,
      check_number:        data[:check_number],
      payment_method:      data[:payment_method],
      paid_amount:         data[:amount] || paid_amount || 0,
      net_amount_received: data[:amount] || net_amount_received || 0,
      payment_received_at: Time.now
    }

    update(params)
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["Name", "Email", "Registered At", "Payment Method", "Paid",
        "Total Fees", "Net Received", "Line Items"]
      all.each do |order|

        order_user = order.user
        order_attendee = order.attendance

        line_item_list = order.order_line_items.map do |i|
          "#{i.quantity} x #{i.name} @ #{i.price}"
        end.join(", ")

        row = [
            order_user.try(:name) || order_attendee.try(:attendee_name) || "Unknown",
            order_user.try(:email) || order_attendee.try(:attendee_name) || "Unknown",
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
