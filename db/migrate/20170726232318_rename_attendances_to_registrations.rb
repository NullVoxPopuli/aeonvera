class RenameAttendancesToRegistrations < ActiveRecord::Migration
  def up
    remove_index :attendances, name: :index_attendances_on_attendee_id
    remove_index :attendances, name: :index_attendances_on_host_id_and_host_type_and_attendance_type
    remove_index :attendances, name: :index_attendances_on_host_id_and_host_type

    rename_table :attendances, :registrations
    rename_column :registrations, :attendance_type, :registration_type

    add_index :registrations, :attendee_id
    add_index :registrations, [:host_id, :host_type]

    drop_table :attendances_discounts

    set_type
  end

  def down
    remove_index :registrations, :attendee_id
    remove_index :registrations, [:host_id, :host_type]

    rename_column :registrations, :registration_type, :attendance_type
    rename_table :registrations, :attendances

    add_index "attendances", ["attendee_id"], name: "index_attendances_on_attendee_id", using: :btree
    add_index "attendances", ["host_id", "host_type", "attendance_type"], name: "index_attendances_on_host_id_and_host_type_and_attendance_type", using: :btree
    add_index "attendances", ["host_id", "host_type"], name: "index_attendances_on_host_id_and_host_type", using: :btree
  end

  def set_type
    Registration.update_all(registration_type: Registration.name )
  end
end
