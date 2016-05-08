class MigrateCompetitionResponsesToOrderLineItems < ActiveRecord::Migration
  def up
    CompetitionResponse.all.each do |cr|
      a = Attendance.with_deleted.find_by_id(cr.attendance_id)
      next unless a

      partner_name = cr.partner_name
      dance_orientation = cr.dance_orientation

      a.orders.each do |order|
        order.order_line_items.each do |order_line_item|
          id = order_line_item.line_item_id
          kind = order_line_item.line_item_type
          next unless kind == Competition.name
          next unless id == cr.competition_id

          order_line_item.partner_name = partner_name
          order_line_item.dance_orientation = dance_orientation

          order_line_item.save_without_timestamping
        end
      end
    end
  end

  def down
    # lol
  end

end
