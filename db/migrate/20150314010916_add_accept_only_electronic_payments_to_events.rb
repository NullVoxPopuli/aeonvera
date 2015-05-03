class AddAcceptOnlyElectronicPaymentsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :accept_only_electronic_payments, :boolean, default: false, null: false
  end
end
