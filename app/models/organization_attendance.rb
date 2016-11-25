# frozen_string_literal: true
# == Schema Information
#
# Table name: attendances
#
#  id                         :integer          not null, primary key
#  attendee_id                :integer
#  host_id                    :integer
#  level_id                   :integer
#  package_id                 :integer
#  pricing_tier_id            :integer
#  interested_in_volunteering :boolean
#  needs_housing              :boolean
#  providing_housing          :boolean
#  metadata                   :text
#  checked_in_at              :datetime
#  deleted_at                 :datetime
#  created_at                 :datetime
#  updated_at                 :datetime
#  attending                  :boolean          default(TRUE), not null
#  dance_orientation          :string(255)
#  host_type                  :string(255)
#  attendance_type            :string(255)
#  transferred_to_name        :string
#  transferred_to_user_id     :integer
#  transferred_at             :datetime
#  transfer_reason            :string
#
# Indexes
#
#  index_attendances_on_attendee_id                                (attendee_id)
#  index_attendances_on_host_id_and_host_type                      (host_id,host_type)
#  index_attendances_on_host_id_and_host_type_and_attendance_type  (host_id,host_type,attendance_type)
#

class OrganizationAttendance < Attendance
  belongs_to :organization, class_name: Organization.name,
                            foreign_key: 'host_id', foreign_type: 'host_type', polymorphic: true

  def total_cost
    line_items.map { |o| o.current_price || 0 }.inject(&:+)
  end
end
