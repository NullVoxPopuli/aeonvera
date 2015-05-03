class AddItemTypeToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :item_type, :string
  end
end
