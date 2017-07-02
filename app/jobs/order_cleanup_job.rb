# frozen_string_literal: true
#
# Some orders are created without any order line items.
# (thanks frontend)
# so, we need to casually clean them up.
#
# orders older than 24 hours that have no order line items
# will be deleted.
#
# TODO: maybe clean up unpaid orders as well?
class OrderCleanupJob < ApplicationJob
  def perform
    clean_orders!
  end

  def clean_orders!
    Order.transaction { clean_orders }
  end

  private

  def clean_orders
    orders = orders_without_order_line_items
    orders.destroy_all
  end

  # TODO: make thing NON-SQL when upgraded to rails 5
  def orders_without_order_line_items
    created_at = Order.arel_table[:created_at]

    Order
      .joins('LEFT OUTER JOIN order_line_items ON orders.id = order_line_items.order_id')
      .group('orders.id')
      .having('count(order_line_items.id) = 0')
      .where(paid: false)
      .where(created_at.lt(1.day.ago))
  end
end
