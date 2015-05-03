class CreateCompetitions < ActiveRecord::Migration
	def change
		create_table :competitions do |t|

			t.string :name
			t.decimal :initial_price
			t.decimal :at_the_door_price
			t.integer :kind, null: false

			t.text :metadata
			
			t.references :event
			t.timestamps
		end
	end
end
