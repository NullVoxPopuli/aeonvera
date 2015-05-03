class CreateDiscountedItems < ActiveRecord::Migration
  def change
    create_table :discounted_items do |t|

      t.timestamps
    end
  end
end
