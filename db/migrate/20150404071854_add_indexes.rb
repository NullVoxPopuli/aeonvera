class AddIndexes < ActiveRecord::Migration
  def change

    add_index :attendances, [:host_id, :host_type]
    add_index :attendances, [:host_id, :host_type, :attendance_type]

    add_index :events, [:domain]
    add_index :organizations, [:domain]

    add_index :line_items, [:host_id, :host_type]
    add_index :line_items, [:host_id, :host_type, :item_type]

    add_index :attendance_line_items, [:attendance_id, :line_item_id]

    add_index :packages, [:event_id]

    add_index :integrations, [:owner_id, :owner_type]

    add_index :order_line_items, [:line_item_id, :line_item_type]
  end
end
