class CreateAttendancesLineItems < ActiveRecord::Migration
  def change
    create_table :attendances_line_items do |t|
    	t.integer :attendance_id
    	t.integer :line_item_id
    end
  end
end
