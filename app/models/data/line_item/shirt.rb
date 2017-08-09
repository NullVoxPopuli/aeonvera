# frozen_string_literal: true

# == Schema Information
#
# Table name: line_items
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  price                  :decimal(, )
#  host_id                :integer
#  deleted_at             :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  item_type              :string(255)
#  picture_file_name      :string(255)
#  picture_content_type   :string(255)
#  picture_file_size      :integer
#  picture_updated_at     :datetime
#  reference_id           :integer
#  metadata               :text
#  expires_at             :datetime
#  host_type              :string(255)
#  description            :text
#  schedule               :text
#  starts_at              :time
#  ends_at                :time
#  duration_amount        :integer
#  duration_unit          :integer
#  registration_opens_at  :datetime
#  registration_closes_at :datetime
#  becomes_available_at   :datetime
#  initial_stock          :integer          default(0), not null
#
# Indexes
#
#  index_line_items_on_host_id_and_host_type                (host_id,host_type)
#  index_line_items_on_host_id_and_host_type_and_item_type  (host_id,host_type,item_type)
#

# TODO: combine prices, inventory, and sizes
class LineItem::Shirt < LineItem
  has_many :order_line_items, -> do
    where(line_item_type: LineItem::Shirt.name)
  end, foreign_key: :line_item_id

  ALL_SIZES = %w(XS S SM M L XL XXL XXXL).freeze
  SIZES_KEY = 'sizes'
  PRICES_KEY = 'prices'
  INVENTORY_KEY = 'inventory'

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

  def initial_stock=(_v); end
end
