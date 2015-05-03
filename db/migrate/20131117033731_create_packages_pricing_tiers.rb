class CreatePackagesPricingTiers < ActiveRecord::Migration
	def change
		create_table :packages_pricing_tiers, id: false do |t|
			t.integer :package_id
			t.integer :pricing_tier_id
		end
	end
end
