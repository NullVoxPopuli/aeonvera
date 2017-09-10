class AddWebsiteToEventsAndOrganization < ActiveRecord::Migration
  def change
    add_column :events, :website, :string
    add_column :organizations, :website, :string
  end
end
