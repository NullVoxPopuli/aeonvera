class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :note
      t.references :host, polymorphic: true
      t.references :target, polymorphic: true
      t.references :author # user

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
