class AddNonregisterableToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :nonregisterable, :boolean, default: false, null: false
  end
end
