class AddDescriptionToLevels < ActiveRecord::Migration
  def change
    add_column :levels, :description, :text
  end
end
