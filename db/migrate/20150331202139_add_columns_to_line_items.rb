class AddColumnsToLineItems < ActiveRecord::Migration
  def change
    change_table(:line_items) do |t|
      # make event_id polymorphic
      t.rename :event_id, :host_id
      t.string :host_type

      t.text :description

      t.text :schedule
      t.time :starts_at
      t.time :ends_at

      t.integer :duration_amount
      t.integer :duration_unit

      t.datetime :registration_opens_at
      t.datetime :registration_closes_at
    end

    # insert initial value to holding_type
    if ActiveRecord::Base.connection.column_exists?(:line_items, :host_type)
      LineItem.all.each do |item|
        item.host_type = Event.name
        item.save
      end
    end
  end
end
