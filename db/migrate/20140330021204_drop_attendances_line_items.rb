class DropAttendancesLineItems < ActiveRecord::Migration
  def change
  	drop_table :attendances_line_items
  end
end
