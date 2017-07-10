class AddDescriptionToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :description, :text
  end
end
