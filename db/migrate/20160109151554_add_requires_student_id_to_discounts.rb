class AddRequiresStudentIdToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :requires_student_id, :bool, default: false, nil: false
  end
end
