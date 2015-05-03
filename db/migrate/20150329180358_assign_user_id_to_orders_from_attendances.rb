class AssignUserIdToOrdersFromAttendances < ActiveRecord::Migration
  def up
    Order.all.each do |order|
      if attendance = order.attendance
        order.update_column(:user_id, attendance.try(:attendee).try(:id))
      end
    end
  end

  def down
    # we'd just remove the column in the migration that adds the user_id
  end
end
