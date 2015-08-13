class HousingProvision < ActiveRecord::Base
  include CSVOutput

  belongs_to :host, polymorphic: true
  belongs_to :attendance, -> { with_deleted }, polymorphic: true
  belongs_to :event, class_name: Event.name,
    foreign_key: 'host_id', foreign_type: 'host_type', polymorphic: true


  has_many :housing_requests

  # for CSV output
  csv_with_columns [
    :attendee_name,
    :attendee_email] +
    column_names,
    exclude: [
      :updated_at, :created_at,
      :attendance_id, :attendance_type,
      :id,
      :host_id, :host_type]


  def attendee_name
    attendance.try(:attendee_name) || "Attendee Not Found or Not Associated"
  end

  def attendee_email
    attendance.try(:attendee).try(:email) || ""
  end
end
