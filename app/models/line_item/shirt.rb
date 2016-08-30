# frozen_string_literal: true
# TODO: combine prices, inventory, and sizes
class LineItem::Shirt < LineItem
  has_many :order_line_items, -> do
    where(line_item_type: LineItem::Shirt.name)
  end, foreign_key: :line_item_id

  ALL_SIZES = %w(XS S SM M L XL XXL XXXL).freeze
  SIZES_KEY = 'sizes'.freeze
  PRICES_KEY = 'prices'.freeze
  INVENTORY_KEY = 'inventory'.freeze

  # in array of available sizes
  # :metadata => {
  #   "sizes" => [
  #      [0] "S",
  #      [1] "M",
  #      [2] "L",
  #      [3] "XS",
  #      [4] "XL",
  #      [5] "2XL"
  #  ],
  #  ...
  def sizes
    metadata[SIZES_KEY] || []
  end

  # in a hash of size => cost
  # :metadata => {
  #   "prices" => {
  #       "S" => "27",
  #       "M" => "27",
  #       "L" => "27",
  #      "XS" => "27",
  #      "XL" => "27",
  #     "2XL" => "27"
  #   }
  #   ...
  def prices
    metadata[PRICES_KEY] || {}
  end

  def price_for_size(size)
    prices[size].presence || price
  end

  # in a hash of size => amount
  # :metadata => {
  #   "prices" => {
  #       "S" => "10",
  #       "M" => "11",
  #       "L" => "5",
  #      "XS" => "4",
  #      "XL" => "3",
  #     "2XL" => "0"
  #   }
  #   ...
  def inventory
    metadata[INVENTORY_KEY] || {}
  end

  def inventory_for_size(size)
    inventory[size].presence || 0
  end

  # clean version of sizes
  # (no "")
  def offered_sizes
    sizes.delete_if(&:empty?)
  end

  # legacy
  def size
    ''
  end

  # stock works a little different for shirts
  def initial_stock
    inventory.inject(0) { |r, (_k, v)| r + v.to_i }
  end

  def initial_stock=(_v);end;
end
