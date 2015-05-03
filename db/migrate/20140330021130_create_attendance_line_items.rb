class CreateAttendanceLineItems < ActiveRecord::Migration
  def change
    create_table :attendance_line_items do |t|
    	t.references :attendance, null: false
    	t.references :line_item, null: false
    	t.integer :quantity
    end
  end
end
