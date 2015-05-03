class CreatePayments < ActiveRecord::Migration
	def change
		create_table :payments do |t|
			t.integer :amount, null: false
			t.boolean :complete, default: false, null: false
			t.text :metadata
			t.references :event, null: false
			t.references :attendance, null: false

			t.datetime :payment_received_at
			t.timestamps
		end
	end
end
