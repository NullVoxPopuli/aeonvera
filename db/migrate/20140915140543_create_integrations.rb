class CreateIntegrations < ActiveRecord::Migration
  def change
    create_table :integrations do |t|
      t.string :kind
      t.text :encrypted_config

      t.references :owner, polymorphic: true
    end
  end
end
