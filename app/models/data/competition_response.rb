# == Schema Information
#
# Table name: competition_responses
#
#  attendance_id     :integer
#  competition_id    :integer
#  id                :integer          not null, primary key
#  dance_orientation :string(255)
#  partner_name      :string(255)
#  deleted_at        :datetime
#  created_at        :datetime
#  updated_at        :datetime
#  attendance_type   :string(255)      default("EventAttendance")
#

class CompetitionResponse < ApplicationRecord
  include SoftDeletable

  belongs_to :competition
  belongs_to :registration, polymorphic: true

  validates :registration, presence: true
  validates :competition, presence: true
  validates :partner_name, presence: true, if: ->(c){ c.competition.requires_partner? }
  validates :dance_orientation, presence: true, if: ->(c){ c.competition.requires_orientation? }
end
