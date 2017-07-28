# frozen_string_literal: true
# == Schema Information
#
# Table name: housing_provisions
#
#  id                         :integer          not null, primary key
#  housing_capacity           :integer
#  number_of_showers          :integer
#  can_provide_transportation :boolean          default(FALSE), not null
#  transportation_capacity    :integer          default(0), not null
#  preferred_gender_to_host   :string(255)
#  has_pets                   :boolean          default(FALSE), not null
#  smokes                     :boolean          default(FALSE), not null
#  notes                      :text
#  registration_id              :integer
#  registration_type            :string(255)
#  host_id                    :integer
#  host_type                  :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#  name                       :string
#  deleted_at                 :datetime
#
# Indexes
#
#  index_housing_provisions_on_registration_id_and_registration_type  (registration_id,registration_type)
#  index_housing_provisions_on_host_id_and_host_type              (host_id,host_type)
#

class HousingProvision < ApplicationRecord
  include CSVOutput
  include SoftDeletable

  belongs_to :host, polymorphic: true
  belongs_to :registration, -> { with_deleted }
  belongs_to :event, class_name: Event.name,
                     foreign_key: 'host_id', foreign_type: 'host_type', polymorphic: true

  has_many :housing_requests

  # for CSV output
  csv_with_columns [
    :attendee_name,
    :attendee_email
  ] +
    column_names,
    exclude: [
      :updated_at, :created_at,
      :registration_id, :registration_type,
      :id,
      :host_id, :host_type
    ]

  def attendee_name
    registration.try(:attendee_name) || 'Attendee Not Found or Not Associated'
  end

  def attendee_email
    registration.try(:attendee).try(:email) || ''
  end
end
