class CreateCustomFields < ActiveRecord::Migration
  def change
    create_table :custom_fields do |t|
      t.string :label
      t.integer :kind # Number, Text, TextArea
      t.text :default_value
      t.boolean :editable, null: false, default: true

      t.references :host, polymorphic: true
      t.references :user #creator

      t.datetime :deleted_at
      t.timestamps
    end

    create_table :custom_field_responses do |t|
        t.text :value

        t.references :writer, polymorphic: true # attendance, user, etc
        t.references :custom_field, null: false

        t.datetime :deleted_at
        t.timestamps
    end

  end
end
