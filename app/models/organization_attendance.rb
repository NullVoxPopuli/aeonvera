# frozen_string_literal: true
class OrganizationAttendance < Attendance
  belongs_to :organization, class_name: Organization.name,
                            foreign_key: 'host_id', foreign_type: 'host_type', polymorphic: true

  def total_cost
    line_items.map { |o| o.current_price || 0 }.inject(&:+)
  end
end
