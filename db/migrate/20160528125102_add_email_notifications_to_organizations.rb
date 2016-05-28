class AddEmailNotificationsToOrganizations < ActiveRecord::Migration
  def change
    change_table 'organizations' do |t|
      t.string 'notify_email'
      t.boolean 'email_all_purchases', default: false, null: false
      t.boolean 'email_membership_purchases', default: false, null: false
    end
  end
end
