class ChangeDanceOrientationToAllowNull < ActiveRecord::Migration
  def change
    change_column_null :attendances, :dance_orientation, true
  end
end
