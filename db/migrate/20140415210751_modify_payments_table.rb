class ModifyPaymentsTable < ActiveRecord::Migration
  def change
    rename_table :payments, :external_payments
    change_column :external_payments, :amount, :integer, null: true

    add_column :external_payments, :payer_id, :string
    add_column :external_payments, :payment_id, :string
  end
end
