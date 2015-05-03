class AddNetAmountReceivedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :net_amount_received, :decimal, null: false, default: 0
    add_column :orders, :total_fee_amount, :decimal, null: false, default: 0

    Order.where(
      payment_method: Payable::Methods::STRIPE,
      paid: true,
      total_fee_amount: 0
    ).each do |order|
      order.set_net_amount_received_and_fees
      order.save
    end
  end
end
