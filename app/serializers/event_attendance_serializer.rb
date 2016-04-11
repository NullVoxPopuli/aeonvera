class EventAttendanceSerializer < AttendanceSerializer
  has_one :housing_request
  has_one :housing_provision
end
