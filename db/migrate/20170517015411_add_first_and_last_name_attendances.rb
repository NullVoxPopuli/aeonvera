class AddFirstAndLastNameAttendances < ActiveRecord::Migration
  def up
    add_column :attendances, :attendee_first_name, :string
    add_column :attendances, :attendee_last_name, :string
    add_column :attendances, :phone_number, :string
    add_column :attendances, :city, :string
    add_column :attendances, :state, :string
    add_column :attendances, :zip, :string

    Attendance.find_each(batch_size: 100) do |attendance|
      next unless attendance.is_a?(EventAttendance)
      next unless attendance.event
      next unless attendance.attendee
      attendance.update(
        city: attendance.metadata_safe['address']&.try(:[], 'city'),
        zip: attendance.metadata_safe['address']&.try(:[], 'zip'),
        state: attendance.metadata_safe['address']&.try(:[], 'state'),

        phone_number: attendance.metadata_safe['phone_number'],

        attendee_first_name: attendance.attendee.first_name,
        attendee_last_name: attendance.attendee.last_name
      )
    end
  end

  def down
    remove_column :attendances, :attendee_first_name
    remove_column :attendances, :attendee_last_name
    remove_column :attendances, :phone_number
    remove_column :attendances, :city
    remove_column :attendances, :state
    remove_column :attendances, :zip
  end
end
