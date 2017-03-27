class AddIsFeeAbsorbedToOrders < ActiveRecord::Migration
  def up
    # Not caring about pre-existing data... cause lets face it,
    # at the time of writing this, my own volunteer groups are the
    # only ones using this...
    add_column :orders, :is_fee_absorbed, :boolean, default: true
  end

  def down
    remove_column :orders, :is_fee_absorbed
  end
end
