class AddMakeAttendeesPayFeesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :make_attendees_pay_fees, :boolean, null: false, default: true
  end
end
