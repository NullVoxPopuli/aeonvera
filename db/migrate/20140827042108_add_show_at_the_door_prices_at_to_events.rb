class AddShowAtTheDoorPricesAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :show_at_the_door_prices_at, :datetime
  end
end
