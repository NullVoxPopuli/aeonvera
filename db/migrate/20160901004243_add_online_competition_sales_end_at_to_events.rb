class AddOnlineCompetitionSalesEndAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :online_competition_sales_end_at, :datetime
  end
end
