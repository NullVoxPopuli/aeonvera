class Level < ActiveRecord::Base
  include SoftDeletable

  belongs_to :user
  belongs_to :event
  has_many :attendances, -> { where(attending: true).order("attendances.created_at DESC") }
  belongs_to :package

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
end
