class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
    	t.string :name
    	t.decimal :price

    	t.references :event
    	t.datetime :deleted_at
    	t.timestamps
    end
  end
end
