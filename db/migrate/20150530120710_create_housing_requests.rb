class CreateHousingRequests < ActiveRecord::Migration

  def up
    add_column :events, :legacy_housing, :boolean, default: false, null: false
    # all existing events have the old housing
    Event.all.each do |event|
      event.legacy_housing = true
      event.save
    end

    create_table :housing_requests do |t|
      t.boolean :need_transportation
      t.boolean :can_provide_transportation, default: false, null: false
      t.integer :transportation_capacity, default: 0, null: false

      t.boolean :allergic_to_pets, default: false, null: false
      t.boolean :allergic_to_smoke, default: false, null: false
      t.string :other_allergies

      t.text :requested_roommates
      t.text :unwanted_roommates

      t.string :preferred_gender_to_house_with

      t.text :notes

      t.references :attendance, polymorphic: true
      t.references :host, polymorphic: true
      t.references :housing_provision
    end
  end

  def down
    remove_column :events, :legacy_housing
    drop_table :housing_requests
  end
end
