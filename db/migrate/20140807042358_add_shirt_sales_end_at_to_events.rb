class AddShirtSalesEndAtToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :shirt_sales_end_at, :datetime
  end
end
