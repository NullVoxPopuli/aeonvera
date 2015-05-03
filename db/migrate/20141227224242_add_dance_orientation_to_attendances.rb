class AddDanceOrientationToAttendances < ActiveRecord::Migration
  def change
    add_column :attendances, :dance_orientation, :string, default: Attendance::FOLLOW, null: false
  end
end
