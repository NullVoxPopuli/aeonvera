class CreatePackages < ActiveRecord::Migration
	def change
		create_table :packages do |t|
			t.string :name
			t.decimal :initial_price
			t.decimal :at_the_door_price

			# i.e.: if limit is 10,
			# 10 leads, 10 follows
			t.integer :attendee_limit
			t.datetime :expires_at
			t.boolean :requires_track

			t.references :event

			t.timestamps
		end
	end
end
