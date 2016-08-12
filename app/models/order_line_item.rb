class OrderLineItem < ActiveRecord::Base
  belongs_to :order, inverse_of: :order_line_items
  # { with_deleted }
  # TODO BUG: https://github.com/rails/rails/pull/16531
  belongs_to :line_item, -> { unscope(where: :deleted_at) },
    polymorphic: true, inverse_of: :order_line_items

  # eager loading doesn't work with polymorphic relationships, so we need to
  # break out line_item in to everything it could be
  # belongs_to :_line_item, -> { unscope(where: :deleted_at).where(item_type: ::LineItem.name) }, foreign_key: 'id', class_name: LineItem.name
  # belongs_to :_line_item_package, -> { unscope(where: :deleted_at).where(item_type: ::Package.name) }, foreign_key: 'id', class_name: Package.name
  # belongs_to :_line_item_lesson, -> { unscope(where: :deleted_at).where(item_type: ::LineItem::Lesson.name) }, foreign_key: 'id', class_name: LineItem::Lesson.name
  # belongs_to :_line_item_membership_option, -> { unscope(where: :deleted_at).where(item_type: ::LineItem::MembershipOption.name) }, foreign_key: 'id', class_name: LineItem::MembershipOption.name
  # belongs_to :_line_item_raffle_ticket, -> { unscope(where: :deleted_at).where(item_type: ::LineItem::RaffleTicket.name) }, foreign_key: 'id', class_name: LineItem::RaffleTicket.name
  # belongs_to :_line_item_shirt, -> { unscope(where: :deleted_at).where(item_type: ::LineItem::Shirt.name) }, foreign_key: 'id', class_name: LineItem::Shirt.name
  # belongs_to :_line_item_discount, -> { unscope(where: :deleted_at) }, foreign_key: 'id', class_name: Discount.name
  # belongs_to :_line_item_competition, -> { unscope(where: :deleted_at) }, foreign_key: 'id', class_name: Competition.name


  # delegate :attendance, to: :order, allow_nil: true

  validates :line_item, presence: true
  validates :line_item, host_matches: { with_host: 'order.host' }
  validates :line_item, restraint_present: true
  validates :line_item_id, :uniqueness => {:scope => [:order_id, :line_item_type]}

  validates :order, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
  validates :partner_name, presence: true, if: :is_competition_requiring_partner?
  validates :dance_orientation, presence: true, if: :is_competition_requiring_orientation?

  delegate :name, to: :line_item

  def total
    price * quantity
  end

  def is_competition_requiring_partner?
    line_item.is_a?(Competition) && line_item.requires_partner?
  end

  def is_competition_requiring_orientation?
    line_item.is_a?(Competition) && line_item.requires_orientation?
  end
end
