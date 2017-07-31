# frozen_string_literal: true
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
  belongs_to :package
  has_many :registrations, -> { where(attending: true).order('registrations.created_at DESC') }

  validates :name, presence: true

  NOTHING = 0
  AUDITION = 1
  INVITATION = 2

  REQUIREMENT_NAMES = {
    NOTHING => '',
    AUDITION => 'Audition',
    INVITATION => 'Invitation'
  }.freeze

  def requirement_name
    REQUIREMENT_NAMES[requirement]
  end

  def is_accessible_to?(user)
    return true if event.hosted_by == user
    return true if user.collaborated_event_ids.include?(event_id)

    false
  end
end
