class CreateAttendances < ActiveRecord::Migration
	def change
		create_table :attendances do |t|
			t.references :attendee
			t.references :event
			t.references :level
			t.references :package
			t.references :pricing_tier

			t.boolean :interested_in_volunteering
			t.boolean :needs_housing
			t.boolean :providing_housing
			t.text :metadata


			t.datetime :checked_in_at
			t.datetime :deleted_at
			t.timestamps
		end
	end
end
