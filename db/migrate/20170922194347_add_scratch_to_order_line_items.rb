class AddScratchToOrderLineItems < ActiveRecord::Migration
  def change
    add_column :order_line_items, :scratch, :boolean, default: false, null: false
  end
end
