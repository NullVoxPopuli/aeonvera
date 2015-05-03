class ChangeColumnDefaultOfOrdersPaymentMethodToCash < ActiveRecord::Migration
  def up
    change_column_default(:orders, :payment_method, Payable::Methods::CASH)
  end

  def down
    change_column_default(:orders, :payment_method, Payable::Methods::PAYPAL)
  end
end
