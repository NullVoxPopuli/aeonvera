class AddIndexesAgain < ActiveRecord::Migration
  def change
    add_index :users, :authentication_token

    add_index :registrations, :level_id
    add_index :registrations, :dance_orientation
  end
end
