class CreateAttendancesDiscounts < ActiveRecord::Migration
  def change
    create_table :attendances_discounts do |t|
      t.integer :attendance_id
      t.integer :discount_id
    end
  end
end
