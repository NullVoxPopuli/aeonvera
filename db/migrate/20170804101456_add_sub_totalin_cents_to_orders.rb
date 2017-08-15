class AddSubTotalinCentsToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :sub_total_in_cents, :integer,
                index: true,
                default: 0,
                null: false

    update_old_data
  end

  def down
    remove_column :orders, :sub_total_in_cents
  end

  def update_old_data
    Order.find_each do |order|
      order.ensure_sub_total_persisted
    end
  end
end
