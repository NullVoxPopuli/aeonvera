class RenameAttendancesToRegistrations < ActiveRecord::Migration
  def up
    remove_index :attendances, name: :index_attendances_on_attendee_id
    remove_index :attendances, name: :index_attendances_on_host_id_and_host_type_and_attendance_type
    remove_index :attendances, name: :index_attendances_on_host_id_and_host_type

    rename_table :attendances, :registrations
    remove_column :registrations, :attendance_type

    add_index :registrations, :attendee_id
    add_index :registrations, [:host_id, :host_type]

    rename_column :housing_requests, :attendance_id, :registration_id
    rename_column :housing_provisions, :attendance_id, :registration_id
    remove_column :housing_requests, :attendance_type
    remove_column :housing_provisions, :attendance_type

    rename_column :orders, :attendance_id, :registration_id
    rename_column :passes, :attendance_id, :registration_id

    drop_table :attendances_discounts
    drop_table :competition_responses

    CustomFieldResponse
      .where(writer_type: 'Attendance')
      .update_all(writer_type: 'Registration')
  end

  def down
    CustomFieldResponse
      .where(writer_type: 'Registration')
      .update_all(writer_type: 'Attendance')

    rename_column :passes, :registration_id, :attendance_id
    rename_column :orders, :registration_id, :attendance_id

    rename_column :housing_requests, :registration_id, :attendance_id
    rename_column :housing_provisions, :registration_id, :attendance_id
    add_column :housing_requests, :attendance_type, :string
    add_column :housing_provisions, :attendance_type, :string

    remove_index :registrations, :attendee_id
    remove_index :registrations, [:host_id, :host_type]

    add_column :registrations, :attendance_type, :string
    rename_table :registrations, :attendances

    add_index "attendances", ["attendee_id"], name: "index_attendances_on_attendee_id", using: :btree
    add_index "attendances", ["host_id", "host_type", "attendance_type"], name: "index_attendances_on_host_id_and_host_type_and_attendance_type", using: :btree
    add_index "attendances", ["host_id", "host_type"], name: "index_attendances_on_host_id_and_host_type", using: :btree
  end
end
