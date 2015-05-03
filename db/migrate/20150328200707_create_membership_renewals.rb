class CreateMembershipRenewals < ActiveRecord::Migration
  def change
    create_table :membership_renewals do |t|
      t.references :user
      t.references :membership_option

      t.datetime :start_date

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
