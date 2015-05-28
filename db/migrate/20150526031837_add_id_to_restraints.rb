class AddIdToRestraints < ActiveRecord::Migration
  def change
    remove_column :restraints, :id
    add_column :restraints, :id, :primary_key
  end
end
