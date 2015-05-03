class AddFieldsToOrganization < ActiveRecord::Migration
  def change
    change_table :organizations do |t|
      t.boolean :make_attendees_pay_fees
    end
  end
end
