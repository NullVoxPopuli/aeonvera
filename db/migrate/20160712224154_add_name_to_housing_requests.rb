class AddNameToHousingRequests < ActiveRecord::Migration
  def change
    add_column :housing_requests, :name, :string
    add_column :housing_provisions, :name, :string
  end
end
