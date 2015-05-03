class AddDeletedAtToAllModels < ActiveRecord::Migration
  def change
    add_column :competitions, :deleted_at, :datetime
    add_column :discounts, :deleted_at, :datetime
    add_column :levels, :deleted_at, :datetime
    add_column :packages, :deleted_at, :datetime
    add_column :pricing_tiers, :deleted_at, :datetime
  end
end
