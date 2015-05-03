class CreateCollaborations < ActiveRecord::Migration
  def change
    create_table :collaborations do |t|
      t.references :user
      t.references :event
      t.string :title
      t.text :permissions

      t.datetime :deleted_at
      t.timestamps
    end
  end
end