class ConvertEventIdToHostOnAttendances < ActiveRecord::Migration
	def change
		change_table(:attendances) do |t|
			t.rename :event_id, :host_id
			t.string :host_type
		end

		if ActiveRecord::Base.connection.column_exists?(:attendances, :host_type)
			Attendance.update_all(host_type: Event.name)
		end

	end
end
