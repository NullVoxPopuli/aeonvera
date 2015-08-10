class OrderLineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :line_item, ->{ with_deleted }, polymorphic: true

  delegate :name, to: :line_item

  def total
    price * quantity
  end
end
