class AddPaidAmountToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :paid_amount, :decimal
    # for existing orders, set paid_amount to calculate_paid_amount
    Order.where(paid: true).each do |order|
      order.paid_amount = order.calculate_paid_amount
      order.save
    end
  end
end
