class AddDomainToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :domain, :string
  end
end
