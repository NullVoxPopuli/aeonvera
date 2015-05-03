class ChangeCollaboratedEventIdToCollaboratedId < ActiveRecord::Migration
  def change
    rename_column :collaborations, :event_id, :collaborated_id
    add_column :collaborations, :collaborated_type, :string
  end
end
