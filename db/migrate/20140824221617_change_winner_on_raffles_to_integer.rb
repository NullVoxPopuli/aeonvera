class ChangeWinnerOnRafflesToInteger < ActiveRecord::Migration
  def change
    remove_column :raffles, :winner_id
    add_column :raffles, :winner_id, :integer
  end
end
