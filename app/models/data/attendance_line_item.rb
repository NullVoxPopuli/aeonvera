# frozen_string_literal: true
class AttendanceLineItem < ApplicationRecord
  belongs_to :attendance
  belongs_to :line_item
end
