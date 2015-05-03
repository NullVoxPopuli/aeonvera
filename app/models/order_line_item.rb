class OrderLineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :line_item, polymorphic: true

  delegate :name, to: :line_item

  def total
    price * quantity
  end
end