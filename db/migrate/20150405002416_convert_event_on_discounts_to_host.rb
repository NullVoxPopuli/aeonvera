class ConvertEventOnDiscountsToHost < ActiveRecord::Migration
  def change
    change_table(:discounts) do |t|
      t.rename :event_id, :host_id
      t.string :host_type
      t.string :discount_type
    end

    if ActiveRecord::Base.connection.column_exists?(:discounts, :host_type)
      Discount.update_all(host_type: Event.name, discount_type: Discount.name)
    end
  end
end
