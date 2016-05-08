module Purchasable
  extend ActiveSupport::Concern

  included do
    has_many :order_line_items, as: :line_item, inverse_of: :line_item

    has_many :orders,
             through: :order_line_items,
             source: :order#,
            #  inverse_of: :line_items

    has_many :purchasers,
             through: :orders,
             source: :attendance,
             inverse_of: :purchased_items
  end
end
