class AddTransfersToAttendances < ActiveRecord::Migration
  def change

    add_column :attendances, :transferred_to_name, :string
    add_column :attendances, :transferred_to_user_id, :integer
    add_column :attendances, :transferred_at, :datetime
    add_column :attendances, :transfer_reason, :string
  end
end
