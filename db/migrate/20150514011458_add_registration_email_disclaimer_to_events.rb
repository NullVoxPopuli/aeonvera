class AddRegistrationEmailDisclaimerToEvents < ActiveRecord::Migration
  def change
    add_column :events, :registration_email_disclaimer, :text
  end
end
