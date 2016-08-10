class MakeHousingSoftDeletable < ActiveRecord::Migration
  def change
    add_column :housing_provisions, :deleted_at, :datetime
    add_column :housing_requests, :deleted_at, :datetime
  end
end
