# == Schema Information
#
# Table name: levels
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  sequence    :integer
#  requirement :integer
#  event_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  deleted_at  :datetime
#
# Indexes
#
#  index_levels_on_event_id  (event_id)
#

class Level < ApplicationRecord
  include SoftDeletable

  belongs_to :user
  belongs_to :event
  has_many :attendances, -> { where(attending: true).order("attendances.created_at DESC") }
  has_many :event_attendances, -> { where(attending: true).order("attendances.created_at DESC") }
  belongs_to :package

  validates :name, presence: true

  #before_destroy { |level|
  #  result = level.attendances.size == 0
  #  if result
  #    level.errors.add(:base, "There are attendees with this level.")
  #    return false
  #  end
  #}


  NOTHING = 0
  AUDITION = 1
  INVITATION = 2

  REQUIREMENT_NAMES = {
    NOTHING => "",
    AUDITION => "Audition",
    INVITATION => "Invitation"
  }


  def requirement_name
    REQUIREMENT_NAMES[requirement]
  end

  def is_accessible_to?(user)
    return true if self.event.hosted_by == user
    return true if user.collaborated_event_ids.include?(self.event_id)

    false
  end
end
