class CreateDiscounts < ActiveRecord::Migration
	def change
		create_table :discounts do |t|

			t.string :name
			t.decimal :value
			t.integer :kind
			t.boolean :disabled, default: false

			t.string :affects

			t.references :event

			t.timestamps
		end
	end
end
