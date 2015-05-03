class AddPaidToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :paid, :boolean, default: false, null: false

    # for all existing orders, set to paid
    Order.all.each do |order|
      order.paid = !!order.payer_id
      order.save_without_timestamping
    end
  end

  def down
    remove_column :orders, :paid
  end
end
