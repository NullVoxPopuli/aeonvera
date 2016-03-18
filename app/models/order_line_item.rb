class OrderLineItem < ActiveRecord::Base
  belongs_to :order
  # { with_deleted }
  # TODO BUG: https://github.com/rails/rails/pull/16531
  belongs_to :line_item, ->{ unscope(where: :deleted_at) }, polymorphic: true

  validates :line_item, presence: true
  validates :order, presence: true
  validates :price, presence: true
  validates :quantity, presence: true

  delegate :name, to: :line_item

  def total
    price * quantity
  end
end
