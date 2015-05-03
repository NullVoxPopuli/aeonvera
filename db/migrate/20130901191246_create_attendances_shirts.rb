class CreateAttendancesShirts < ActiveRecord::Migration
  def change
    create_table :attendances_shirts do |t|
    	t.integer :attendance_id
    	t.integer :shirt_id
    end
  end
end
