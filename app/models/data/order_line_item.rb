# frozen_string_literal: true
# == Schema Information
#
# Table name: order_line_items
#
#  id                :integer          not null, primary key
#  order_id          :integer
#  line_item_id      :integer
#  line_item_type    :string(255)
#  price             :decimal(, )      default(0.0), not null
#  quantity          :integer          default(1), not null
#  created_at        :datetime
#  updated_at        :datetime
#  size              :string
#  color             :string
#  dance_orientation :string
#  partner_name      :string
#  picked_up_at      :datetime
#
# Indexes
#
#  index_order_line_items_on_line_item_id_and_line_item_type  (line_item_id,line_item_type)
#  index_order_line_items_on_order_id                         (order_id)
#

class OrderLineItem < ApplicationRecord
  belongs_to :order, inverse_of: :order_line_items
  # { with_deleted }
  # TODO BUG: https://github.com/rails/rails/pull/16531
  belongs_to :line_item, -> { unscope(where: :deleted_at) },
    polymorphic: true, inverse_of: :order_line_items

  # delegate :attendance, to: :order, allow_nil: true

  validates :line_item, presence: true
  validates :line_item, host_matches: { with_host: 'order.host' }
  validates :line_item, restraint_present: true
  validates :line_item_id, uniqueness: { scope: [:order_id, :line_item_type] }

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
