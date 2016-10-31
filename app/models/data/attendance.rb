# Rules about an Attendance
# - Only one unpaid order at a time
#   - if the attendance owes money, there will be an unpaid order
# - Must belong to a host (Event, Organization, etc)
class Attendance < ActiveRecord::Base
  self.inheritance_column = "attendance_type"

  include SoftDeletable
  include HasMetadata
  include HasAddress
  include CSVOutput

  LEAD = "Lead"
  FOLLOW = "Follow"

  has_one :housing_request
  has_one :housing_provision

  belongs_to :attendee, class_name: "User"
  # for an attendance, we don't care if any of our
  # references are deleted, we want to know what they were
  def attendee; User.unscoped{ super }; end

  belongs_to :host, -> { unscope(where: :deleted_at) }, polymorphic: true

  has_many :custom_field_responses, as: :writer, dependent: :destroy
  has_many :orders
  has_many :order_line_items, through: :orders
  has_many :purchased_items,
    through: :order_line_items,
    source: :line_item,
    inverse_of: :purchasers

  has_many :raffle_tickets,
    through: :order_line_items,
    source: :line_item,
    source_type: LineItem::RaffleTicket.name

  scope :with_line_items, -> {
    joins(:line_items).group("attendances.id")
  }
  scope :with_shirts, ->{
    joins(:shirts).group("attendances.id")
  }

  scope :participating_in_raffle, ->(raffle_id){
    joins(:raffle_tickets).where("reference_id = #{raffle_id}")
  }

  scope :with_raffle_tickets, ->(raffle_id){
    joins(:raffle_tickets).where(id: raffle_id).group("attendances.id")
  }

  scope :with_unpaid_orders, ->{
    joins(:orders).where('orders.paid != true').uniq
  }

  scope :without_orders, ->{
    joins('LEFT OUTER JOIN "orders" ON "orders"."attendance_id" = "attendances"."id"').
    where('orders.attendance_id IS NULL').uniq
  }

  scope :unpaid, ->{
    joins('LEFT OUTER JOIN "orders" ON "orders"."attendance_id" = "attendances"."id"').
    where('orders.attendance_id IS NULL OR orders.paid != true').uniq
  }


  scope :created_after, ->(time){ where("created_at > ?", time) }
  scope :created_before, ->(time){ where("created_at < ?", time) }

  scope :leads, ->{ where(dance_orientation: LEAD) }
  scope :follows, ->{ where(dance_orientation: FOLLOW) }
  scope :volunteering, -> { where(interested_in_volunteering: true) }

  accepts_nested_attributes_for :custom_field_responses
  accepts_nested_attributes_for :housing_request
  accepts_nested_attributes_for :housing_provision


  def add(object)
    send("#{object.class.name.demodulize.underscore.pluralize}") << object
  end

  def unpaid_order
    self.orders.unpaid.last
  end

  def is_using_discount?(discount_id)
    self.orders.map{|o|
      o.order_line_items.where(line_item_type: Discount.name, line_item_id: discount_id)
    }.flatten.compact.any?
  end

  def mark_orders_as_paid!(data)
    check_number = data[:check_number]
    payment_method = data[:payment_method]

    orders = self.orders.unpaid
    if orders.empty?
      new_order = self.new_order
      new_order.payment_method = payment_method
      if check_number
        new_order.add_check_number(check_number)
      end
      orders = [new_order]
    end

    orders.map{ |o|
      o.payment_method = payment_method
      o.paid = true
      o.paid_amount = o.total
      o.net_amount_received = o.paid_amount
      o.total_fee_amount = 0
      o.save
    }
  end

  def ordered_shirts
    result = []
    orders.each do |order|
      result = order.order_line_items.select{|li|
        li.line_item_type == LineItem::Shirt.name
      }
    end
    result = result.flatten
  end

  def attendee_email
    # TODO: add the email of the transfer person?
    if self.attendee
      attendee.email
    else
      self.metadata['email']
    end
  end

  def attendee_name
    # for transfers
    if transferred_to_name.present?
      return transferred_to_name
    end

    if self.attendee
      # normal

      # have to titleize, cause some people aren't OCD enough
      # to type their name with proper capitalization....
      self.attendee.name.titleize
    elsif (first = self.metadata["first_name"]) &&
      # User-less Registration

      (last = self.metadata["last_name"])
      "#{first} #{last}"
    else
      "Name not given"
    end
  end

  def package_name
    self.package.try(:name)
  end

  def level_name
    self.level.try(:name)
  end

  def registered_at
    self.created_at
  end



  def amount_owed
    # later, calculate multiple orders
    if orders.present?
      orders.map{|o| o.paid? ? 0 : o.total }.inject(&:+)
    else
      0 # no orders
    end
  end

  alias_method :remaining_balance, :amount_owed

  def paid_amount
    orders.present? ? orders.map{|o| o.try(:current_paid_amount) || 0}.inject(&:+) : 0
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
      "Paid"
    end
  end

  def has_paid_orders?
    self.orders.where(paid: true).count > 0
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

end
