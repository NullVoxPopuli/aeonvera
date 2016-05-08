class OrderLineItem < ActiveRecord::Base
  belongs_to :order, inverse_of: :order_line_items
  # { with_deleted }
  # TODO BUG: https://github.com/rails/rails/pull/16531
  belongs_to :line_item, -> { unscope(where: :deleted_at) },
    polymorphic: true, inverse_of: :order_line_items

  # delegate :attendance, to: :order, allow_nil: true

  validates :line_item, presence: true
  validates :line_item, host_matches: { with_host: 'order.host' }
  validates :line_item, restraint_present: true

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
