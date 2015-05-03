class CreateShirts < ActiveRecord::Migration
	def change
		create_table :shirts do |t|

			t.string :name
			t.decimal :initial_price
			t.decimal :at_the_door_price

			t.string :sizes

			t.datetime :expires_at

			t.references :event
			t.timestamps
		end
	end
end
