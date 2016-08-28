class AddAmountInStockToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :initial_stock, :integer, default: 0, null: false
    add_column :order_line_items, :picked_up_at, :datetime
  end
end
