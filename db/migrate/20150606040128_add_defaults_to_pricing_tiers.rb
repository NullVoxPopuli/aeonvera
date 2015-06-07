class AddDefaultsToPricingTiers < ActiveRecord::Migration
  def up
    change_column_default(:pricing_tiers, :increase_by_dollars, 0)
  end

  def down
    change_column_default(:pricing_tiers, :increase_by_dollars, nil)
  end
end
