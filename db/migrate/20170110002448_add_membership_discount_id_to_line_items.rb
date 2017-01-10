class AddMembershipDiscountIdToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :membership_discount_id, :integer
  end
end
