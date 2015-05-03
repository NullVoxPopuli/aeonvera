class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :tagline
      t.string :city
      t.string :state

      t.boolean :beta, default: false, null: false


      t.references :owner

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
