class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :payment_token
      t.string :payer_id
      t.text :metadata
      
      t.references :attendance
      t.references :event
      t.timestamps
    end
  end
end
