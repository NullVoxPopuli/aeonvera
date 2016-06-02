class AddContactEmailToEventsAndOrganizations < ActiveRecord::Migration
  def change
    change_table 'events' do |t|
      t.string 'contact_email'
    end

    change_table 'organizations' do |t|
      t.string 'contact_email'
    end
  end
end
