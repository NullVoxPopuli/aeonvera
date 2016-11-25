# frozen_string_literal: true
class AttendanceLineItem < ActiveRecord::Base
  belongs_to :attendance
  belongs_to :line_item
end
