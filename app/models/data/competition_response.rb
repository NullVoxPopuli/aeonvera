class CompetitionResponse < ActiveRecord::Base
  include SoftDeletable

  belongs_to :competition
  belongs_to :attendance, polymorphic: true

  validates :attendance, presence: true
  validates :competition, presence: true
  validates :partner_name, presence: true, if: ->(c){ c.competition.requires_partner? }
  validates :dance_orientation, presence: true, if: ->(c){ c.competition.requires_orientation? }
end
