class AddFieldsToShirtSelection < ActiveRecord::Migration
  def up
    add_column :attendance_line_items, :size, :string
    add_column :attendance_line_items, :line_item_type, :string#

    AttendanceLineItem.all.each do |ali|
      id = ali.line_item_id
      li = LineItem.find(id)
      ali.line_item_type = li.class.name
      ali.save
    end
  end

  def down
    remove_columns :attendance_line_item, :size
    remove_columns :attendance_line_item, :line_item_type
  end
end
