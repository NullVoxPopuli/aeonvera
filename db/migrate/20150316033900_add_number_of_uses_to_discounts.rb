class AddNumberOfUsesToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :allowed_number_of_uses, :integer
  end
end
