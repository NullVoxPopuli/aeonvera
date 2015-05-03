class AddAllowDiscountsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :allow_discounts, :boolean, default: true, null: false
  end
end
