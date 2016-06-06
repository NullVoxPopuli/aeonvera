class AddPricingTierToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :pricing_tier, index: true
  end
end
