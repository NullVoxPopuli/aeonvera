class AddColumnsToOrderLineItems < ActiveRecord::Migration
  def change
    change_table(:order_line_items) do |t|
      # shirts / other
      t.string :shirt_size
      t.string :color

      # competitions
      # the line_item is the competition,
      # attendance should be required
      # (must be logged in to participate in competitions)
      t.string :dance_orientation
      t.string :partner_name
    end
  end
end
