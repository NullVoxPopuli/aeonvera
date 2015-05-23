class CreateCompetitionResponses < ActiveRecord::Migration
  def change
    rename_table :attendances_competitions, :competition_responses
    remove_column :competition_responses, :id
    add_column :competition_responses, :id, :primary_key
    add_column :competition_responses, :dance_orientation, :string
    add_column :competition_responses, :partner_name, :string
    add_column :competition_responses, :deleted_at, :datetime

    add_column :competition_responses, :created_at, :datetime
    add_column :competition_responses, :updated_at, :datetime

    add_column :competition_responses, :attendance_type, :string, default: EventAttendance.name
  end
end
