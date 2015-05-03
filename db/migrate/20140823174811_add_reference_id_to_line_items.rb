class AddReferenceIdToLineItems < ActiveRecord::Migration
  def change
  	add_column :line_items, :reference_id, :integer
  	add_column :line_items, :metadata, :text
  end
end
