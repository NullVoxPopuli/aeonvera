class AddBecomesAvailableAtToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :becomes_available_at, :datetime
  end
end
