class AddLogosToEventAndOrganization < ActiveRecord::Migration
  def change
    add_attachment :events, :logo
    add_attachment :organizations, :logo
  end
end
