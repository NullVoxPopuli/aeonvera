class AddAllowCombinedDiscountsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :allow_combined_discounts, :boolean, default: true, null: false
  end
end
