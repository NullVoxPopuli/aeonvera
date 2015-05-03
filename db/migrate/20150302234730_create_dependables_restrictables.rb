class CreateDependablesRestrictables < ActiveRecord::Migration
  def change
    create_table :restraints do |t|
      t.references :dependable, polymorphic: true
      t.references :restrictable, polymorphic: true
    end
  end
end
