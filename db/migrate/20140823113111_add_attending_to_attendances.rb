class AddAttendingToAttendances < ActiveRecord::Migration
  def change
    add_column :attendances, :attending, :boolean, default: true, null: false
    Attendance.only_deleted.each do |attendance|
      attendance.deleted_at = nil
      attendance.attending = false
      attendance.save
    end
  end
end
