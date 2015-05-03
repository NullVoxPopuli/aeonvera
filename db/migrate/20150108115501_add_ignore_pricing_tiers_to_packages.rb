class AddIgnorePricingTiersToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :ignore_pricing_tiers, :boolean, null: false, default: false
  end
end
