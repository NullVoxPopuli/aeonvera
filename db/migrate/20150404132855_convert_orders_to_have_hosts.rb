class ConvertOrdersToHaveHosts < ActiveRecord::Migration
  def change
    change_table(:orders) do |t|
      t.rename :event_id, :host_id
      t.string :host_type
    end

    if ActiveRecord::Base.connection.column_exists?(:orders, :host_type)
      Order.update_all(host_type: Event.name)
    end

    add_index :orders, [:host_id, :host_type]

  end
end
