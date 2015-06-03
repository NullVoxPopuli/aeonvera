class CreateHousingProvisions < ActiveRecord::Migration
  def up
    create_table :housing_provisions do |t|
      t.integer :housing_capacity
      t.integer :number_of_showers

      t.boolean :can_provide_transportation, default: false, null: false
      t.integer :transportation_capacity, default: 0, null: false
      t.string :preferred_gender_to_host

      t.boolean :has_pets, default: false, null: false
      t.boolean :smokes, default: false, null: false

      t.text :notes

      t.references :attendance, polymorphic: true
      t.references :host, polymorphic: true

      t.timestamps
    end
  end

  def down
    drop_table :housing_provisions
  end
end
