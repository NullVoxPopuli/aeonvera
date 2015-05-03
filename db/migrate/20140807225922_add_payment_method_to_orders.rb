class AddPaymentMethodToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :payment_method, :string, null: false, default: Payable::Methods::PAYPAL
  end
end
