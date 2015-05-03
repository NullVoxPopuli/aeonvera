class RemoveDefaultDanceOrientationOnAttendances < ActiveRecord::Migration
  def change
    change_column_default(:attendances, :dance_orientation, nil)
  end
end
