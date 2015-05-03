class ConvertAttendanceToSti < ActiveRecord::Migration
  def change
    change_table :attendances do |t|
      t.string :attendance_type
    end

    Attendance.update_all(attendance_type: EventAttendance.name)
  end
end
