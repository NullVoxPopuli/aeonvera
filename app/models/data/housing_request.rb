# == Schema Information
#
# Table name: housing_requests
#
#  id                             :integer          not null, primary key
#  need_transportation            :boolean
#  can_provide_transportation     :boolean          default(FALSE), not null
#  transportation_capacity        :integer          default(0), not null
#  allergic_to_pets               :boolean          default(FALSE), not null
#  allergic_to_smoke              :boolean          default(FALSE), not null
#  other_allergies                :string(255)
#  requested_roommates            :text
#  unwanted_roommates             :text
#  preferred_gender_to_house_with :string(255)
#  notes                          :text
#  attendance_id                  :integer
#  attendance_type                :string(255)
#  host_id                        :integer
#  host_type                      :string(255)
#  housing_provision_id           :integer
#  created_at                     :datetime
#  updated_at                     :datetime
#  name                           :string
#  deleted_at                     :datetime
#
# Indexes
#
#  index_housing_requests_on_attendance_id_and_attendance_type  (attendance_id,attendance_type)
#  index_housing_requests_on_host_id_and_host_type              (host_id,host_type)
#

class HousingRequest < ApplicationRecord
  include CSVOutput
  include SoftDeletable

  # Store the list of requested and unwanted
  # roommates as a list of strings
  serialize :requested_roommates, JSON
  serialize :unwanted_roommates, JSON

  belongs_to :host, polymorphic: true
  belongs_to :registration, -> { with_deleted }, polymorphic: true

  belongs_to :event, class_name: Event.name,
    foreign_key: 'host_id', foreign_type: 'host_type', polymorphic: true

  # TODO: Implement #177
  belongs_to :housing_provision

  # alias so that we can use proper english
  alias_attribute :needs_transportation, :need_transportation

  validates :transportation_capacity, presence: true

  # for CSV output
  csv_with_columns [
    :attendee_name,
    :attendee_email,
    :requested_roommate_name_list,
    :unwanted_roommate_name_list] +
    column_names,
    exclude: [
      :updated_at, :created_at,
      :registration_id, :registration_type,
      :id,
      :requested_roommates, :unwanted_roommates,
      :host_id, :host_type]

  def attendee_name
    attendance.try(:attendee_name) || "Attendee Not Found or Not Associated"
  end

  def attendee_email
    attendance.try(:attendee).try(:email) || ""
  end

  def requested_roommate_names
    requested_roommates || []
  end

  def unwanted_roommate_names
    unwanted_roommates || []
  end

  def requested_roommate_name_list
    requested_roommate_names.keep_if{|n| n.present?}.join(", ")
  end

  def unwanted_roommate_name_list
    unwanted_roommate_names.keep_if{|n| n.present?}.join(", ")
  end


end
