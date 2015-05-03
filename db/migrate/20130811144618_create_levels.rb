class CreateLevels < ActiveRecord::Migration
	def change
		create_table :levels do |t|

			t.string :name
			t.integer :sequence
			t.integer :requirement

			t.references :event
			t.timestamps
		end
	end
end
