class AddExpiresAtToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :expires_at, :datetime
  end
end
