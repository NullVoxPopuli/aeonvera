class AddBetaToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :beta, :boolean, null: false, default: false
  end
end
