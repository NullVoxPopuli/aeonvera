class CreateOrderLineItems < ActiveRecord::Migration
  def change
    create_table :order_line_items do |t|
      t.references :order
      t.references :line_item, :polymorphic => true
      t.decimal :price, default: 0, null: false
      t.integer :quantity, default: 1, null: false
      t.timestamps
    end
  end
end
