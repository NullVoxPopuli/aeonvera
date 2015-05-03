class AddWinnerIdToRaffles < ActiveRecord::Migration
  def change
    add_column :raffles, :winner_id, :boolean
  end
end
