class CreatePasses < ActiveRecord::Migration
  def change
    create_table :passes do |t|
      t.string :name
      t.string :intended_for
      t.integer :percent_off

      t.references :discountable
      t.string :discountable_type

      t.references :attendance
      t.references :event
      t.references :user
      t.timestamps
    end
  end
end
