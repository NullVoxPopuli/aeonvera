class AddIndexes < ActiveRecord::Migration
  def change
    add_index :attendances, :attendee_id
    add_index :competitions, :event_id
    add_index :collaborations, :user_id
    add_index :collaborations, [:collaborated_id, :collaborated_type]

    add_index :custom_field_responses, [:writer_id, :writer_type]
    add_index :custom_fields, [:host_id, :host_type]
    add_index :discounts, [:host_id, :host_type]

    add_index :housing_requests, [:host_id, :host_type]
    add_index :housing_requests, [:attendance_id, :attendance_type]
    add_index :housing_provisions, [:host_id, :host_type]
    add_index :housing_provisions, [:attendance_id, :attendance_type]

    add_index :levels, :event_id

    add_index :membership_renewals, :user_id
    add_index :membership_renewals, :membership_option_id
    add_index :membership_renewals, [:user_id, :membership_option_id]

    add_index :order_line_items, :order_id

    add_index :orders, :user_id

    add_index :pricing_tiers, :event_id
    add_index :restraints, [:dependable_id, :dependable_type]
    add_index :restraints, [:restrictable_id, :restrictable_type]
    add_index :sponsorships, [:discount_id, :discount_type]
  end
end
