class AddCreatedByToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :created_by, index: true
  end
end
