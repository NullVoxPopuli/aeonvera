# frozen_string_literal: true
module Api
  class EventAttendanceSerializer < AttendanceSerializer
    has_one :housing_request
    has_one :housing_provision
    has_many :custom_field_responses
  end
end
