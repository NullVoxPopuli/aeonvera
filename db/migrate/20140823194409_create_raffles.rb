class CreateRaffles < ActiveRecord::Migration
  def change
    create_table :raffles do |t|
    	t.string :name
    	t.references :event
    	t.timestamp :deleted_at
    	t.timestamps
    end
  end
end
