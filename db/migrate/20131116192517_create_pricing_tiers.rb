class CreatePricingTiers < ActiveRecord::Migration
  def change
    create_table :pricing_tiers do |t|

    	t.decimal :increase_by_dollars
    	t.datetime :date
    	t.integer :registrants
    	t.references :event
    end
  end
end
  	