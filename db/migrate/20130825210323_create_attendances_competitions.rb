class CreateAttendancesCompetitions < ActiveRecord::Migration
	def change
		create_table :attendances_competitions, id: false do |t|
			t.integer :attendance_id
			t.integer :competition_id
		end
	end
end